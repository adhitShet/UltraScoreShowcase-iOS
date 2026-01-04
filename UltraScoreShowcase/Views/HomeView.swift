import SwiftUI

struct HomeView: View {
    @State private var showMenu = false
    @State private var selectedDate = Date()
    @State private var showBatteryNotification = true
    @State private var showDatePicker = false

    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                AppColors.background
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 16) {
                        // Battery Notification
                        if showBatteryNotification {
                            BatteryNotificationCard(onDismiss: {
                                withAnimation(.spring(response: 0.3)) {
                                    showBatteryNotification = false
                                }
                            })
                            .transition(.move(edge: .top).combined(with: .opacity))
                        }

                        // Ultra Score
                        NavigationLink(destination: EffortScoreDetailsView()) {
                            UltraScoreCard(
                                score: 79,
                                contributors: [
                                    ScoreContributor(name: "Movement", value: 88, route: "movement"),
                                    ScoreContributor(name: "Sleep", value: 65, route: "sleep"),
                                    ScoreContributor(name: "Recovery", value: 45, route: "recovery")
                                ]
                            )
                        }
                        .buttonStyle(PlainButtonStyle())

                        // Health Intelligence
                        HealthIntelligenceCard()

                        // Activity Summary
                        ActivitySummaryCard()

                        // Now Block
                        NowBlockCard(heartRate: 72, stressLevel: "Low", steps: 8432)

                        // Sleep Screener
                        SleepScreenerCard()

                        // Cycle Health
                        CycleHealthCard()

                        // Biomarkers Snapshot
                        BiomarkersSnapshotCard()
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    MenuButton(action: { showMenu = true })
                }

                ToolbarItem(placement: .principal) {
                    DeviceSelector()
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    DateNavigator(selectedDate: $selectedDate, showPicker: $showDatePicker)
                }
            }
        }
        .sheet(isPresented: $showDatePicker) {
            DatePickerSheet(selectedDate: $selectedDate, isPresented: $showDatePicker)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
    }
}

// MARK: - Menu Button
struct MenuButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack(alignment: .topTrailing) {
                Image(systemName: "line.3.horizontal")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppColors.foreground)
                    .frame(width: 40, height: 40)
                    .background(AppColors.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)

                // Notification dot
                Circle()
                    .fill(AppColors.warning)
                    .frame(width: 8, height: 8)
                    .offset(x: 2, y: -2)
            }
        }
    }
}

// MARK: - Device Selector (ULTRAHUMAN with chevron)
struct DeviceSelector: View {
    @State private var showDeviceSheet = false

    var body: some View {
        Button(action: { showDeviceSheet = true }) {
            HStack(spacing: 4) {
                Text("ULTRAHUMAN")
                    .font(.system(size: 12, weight: .bold))
                    .tracking(1.5)
                    .foregroundColor(AppColors.foreground)

                Image(systemName: "chevron.down")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(AppColors.mutedForeground)
            }
        }
        .sheet(isPresented: $showDeviceSheet) {
            DevicePickerSheet(isPresented: $showDeviceSheet)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
    }
}

// MARK: - Device Picker Sheet
struct DevicePickerSheet: View {
    @Binding var isPresented: Bool
    @State private var selectedDevice = "Ring"

    private let devices = ["Ring", "M1", "Rare"]

    var body: some View {
        NavigationStack {
            List {
                ForEach(devices, id: \.self) { device in
                    Button(action: {
                        selectedDevice = device
                        isPresented = false
                    }) {
                        HStack {
                            Text(device)
                                .foregroundColor(AppColors.foreground)

                            Spacer()

                            if selectedDevice == device {
                                Image(systemName: "checkmark")
                                    .foregroundColor(AppColors.primary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Select Device")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        isPresented = false
                    }
                    .foregroundColor(AppColors.primary)
                }
            }
        }
    }
}

// MARK: - Date Navigator
struct DateNavigator: View {
    @Binding var selectedDate: Date
    @Binding var showPicker: Bool

    private var isToday: Bool {
        Calendar.current.isDateInToday(selectedDate)
    }

    private var displayText: String {
        if isToday {
            return "Today"
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: selectedDate)
    }

    var body: some View {
        HStack(spacing: 2) {
            Button(action: {
                withAnimation(.spring(response: 0.3)) {
                    selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate) ?? selectedDate
                }
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(AppColors.foreground)
                    .frame(width: 28, height: 28)
            }

            Button(action: { showPicker = true }) {
                Text(displayText)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(AppColors.foreground)
                    .frame(minWidth: 50)
            }

            Button(action: {
                withAnimation(.spring(response: 0.3)) {
                    selectedDate = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate) ?? selectedDate
                }
            }) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(AppColors.foreground)
                    .frame(width: 28, height: 28)
            }
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 6)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Date Picker Sheet
struct DatePickerSheet: View {
    @Binding var selectedDate: Date
    @Binding var isPresented: Bool

    var body: some View {
        NavigationStack {
            VStack {
                DatePicker(
                    "Select Date",
                    selection: $selectedDate,
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .tint(AppColors.primary)
                .padding()

                Spacer()
            }
            .background(AppColors.background)
            .navigationTitle("Select Date")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Today") {
                        selectedDate = Date()
                    }
                    .foregroundColor(AppColors.primary)
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        isPresented = false
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(AppColors.primary)
                }
            }
        }
    }
}

// MARK: - Battery Notification
struct BatteryNotificationCard: View {
    let onDismiss: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "bell.fill")
                .font(.system(size: 14))
                .foregroundColor(AppColors.warning)
                .frame(width: 32, height: 32)
                .background(AppColors.warning.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 2) {
                Text("Your ring battery is less than 30%")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(AppColors.foreground)

                Text("Put the ring on the charger")
                    .font(.system(size: 11))
                    .foregroundColor(AppColors.mutedForeground)
            }

            Spacer()

            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(AppColors.warning)
                    .frame(width: 28, height: 28)
                    .background(AppColors.warning.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.warning.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(AppColors.warning.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

#Preview {
    HomeView()
        .preferredColorScheme(.light)
}
