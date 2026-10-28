# Q16: Azure VM Troubleshooting

## Objective
To troubleshoot connectivity problems when an Azure virtual machine is running but administrators cannot connect to it.

## (a) Verify Provisioning and Power States

1. Sign in to the Azure portal.
2. Open Virtual machines and select the affected VM.
3. Check the **Provisioning state** and **Power state**.
4. Confirm that provisioning succeeded and the VM is running.
5. Review Boot diagnostics and resource health if the VM is unavailable.

## (b) Network Security Group Rules

A Network Security Group (NSG) filters inbound and outbound network traffic using rules based on source, destination, port, protocol, and priority.

An incorrect or missing inbound rule for SSH (TCP 22) or RDP (TCP 3389) may prevent administrative access. Outbound restrictions may also block required communication. Check effective security rules and permit only trusted sources and necessary ports.

## (c) Subnet and Routing Configuration

Incorrect subnet configuration, route table entries, or user-defined routes can prevent traffic from reaching the VM. Verify subnet associations, the VM's network interface, effective routes, and any required VPN or peering configuration.

## (d) Secure Troubleshooting Without Unnecessary Public Exposure

Use **Azure Bastion** to connect to supported VMs through the Azure portal without exposing SSH or RDP directly to the public internet. Alternatively, use VPN or ExpressRoute for private connectivity.

Review NSG rules, routing, boot diagnostics, and VM health before making changes. Avoid opening administrative ports to all internet addresses.

## Conclusion
Azure VM connectivity issues can be investigated by checking provisioning and power states, NSG rules, routing, and diagnostics. Azure Bastion or private network connectivity provides a safer troubleshooting approach.
