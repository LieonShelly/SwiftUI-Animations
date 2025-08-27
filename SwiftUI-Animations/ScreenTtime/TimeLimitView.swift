import ManagedSettings

struct TimeLimitView: View {
    let selection: FamilyActivitySelection
    @State private var selectedMinutes = 30
    let store = ManagedSettingsStore()

    var body: some View {
        VStack(spacing: 20) {
            Text("设置限制时间")
                .font(.headline)

            Picker("时间（分钟）", selection: $selectedMinutes) {
                ForEach([15, 30, 60, 120], id: \.self) { value in
                    Text("\(value) 分钟")
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            Button("应用限制") {
                applyLimit()
            }
            .padding()
        }
        .navigationTitle("时间限制")
    }

    func applyLimit() {
        // 将选定的 App 添加到受限列表
        store.shield.applications = selection.applicationTokens

        // **这里 MVP 先做即时限制，不做时间逻辑**
        // 如果要按时间限制，需要用 DeviceActivitySchedule + DeviceActivityMonitor
        print("已限制：\(selection.applicationTokens.count) 个 App")
    }
}
