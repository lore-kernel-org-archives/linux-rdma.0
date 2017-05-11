From: bugzilla-daemon-590EEB7GvNiWaY/ihj7yzEB+6BGkLq7r@public.gmane.org
Subject: [Bug 195723] New: mlx4: Toggling the port mode while srp_daemon is
 running triggers a kernel oops
Date: Thu, 11 May 2017 22:54:09 +0000
Message-ID: <bug-195723-11804@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=195723

            Bug ID: 195723
           Summary: mlx4: Toggling the port mode while srp_daemon is
                    running triggers a kernel oops
           Product: Drivers
           Version: 2.5
    Kernel Version: 4.11.0
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Infiniband/RDMA
          Assignee: drivers_infiniband-rdma-ztI5WcYan/vQLgFONoPN62D2FQJk+8+b@public.gmane.org
          Reporter: bvanassche-HInyCGIudOg@public.gmane.org
        Regression: No

How to reproduce:
srp_daemon -ecd /dev/infiniband/umad0 -R 10 &
sleep 10
echo eth > /sys/class/infiniband/mlx4_0/device/mlx4_port1
sleep 10
echo ib > /sys/class/infiniband/mlx4_0/device/mlx4_port1

Result:

BUG: unable to handle kernel paging request at 000000000001a730
IP: queued_spin_lock_slowpath+0xf2/0x190
PGD 309132067 
PUD 2eaf3f067 
PMD 0 

Oops: 0002 [#1] SMP
Modules linked in: fuse ib_srp scsi_transport_srp uio dm_service_time
netconsole xt_CHECKSUM iptable_mangle ipt_MASQUERADE nf_nat_masquerade_ipv4
iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack
nf_conntrack libcrc32c ipt_REJECT nf_reject_ipv4 xt_tcpudp tun bridge stp llc
ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter ip_tables
x_tables ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm configfs ib_cm
iw_cm mlx4_ib af_packet ib_core msr sb_edac edac_core x86_pkg_temp_thermal
intel_powerclamp coretemp mlx4_core tg3 ptp kvm_intel pps_core ipmi_ssif
iTCO_wdt devlink libphy kvm irqbypass crct10dif_pclmul iTCO_vendor_support
crc32_pclmul crc32c_intel ghash_clmulni_intel pcbc aesni_intel aes_x86_64
mei_me crypto_simd glue_helper dcdbas ipmi_si lpc_ich cryptd pcspkr wmi shpchp
mfd_core ioatdma mei ipmi_devintf ipmi_msghandler dca tpm_tis tpm_tis_core
button tpm acpi_pad hid_generic usbhid mgag200 i2c_algo_bit drm_kms_helper
syscopyarea sysfillrect sysimgblt fb_sys_fops ttm drm sr_mod cdrom ehci_pci
xhci_pci ehci_hcd xhci_hcd usbcore usb_common sg dm_multipath dm_mod
scsi_dh_rdac scsi_dh_emc scsi_dh_alua autofs4 [last unloaded: brd]
CPU: 4 PID: 10991 Comm: bash Tainted: G          I     4.11.0-dbg+ #2
Hardware name: Dell Inc. PowerEdge R430/03XKDV, BIOS 1.0.2 11/17/2014
task: ffff88017262b140 task.stack: ffffc90002684000
RIP: 0010:queued_spin_lock_slowpath+0xf2/0x190
RSP: 0018:ffffc90002687b40 EFLAGS: 00010006
RAX: 000000000001a730 RBX: ffff88038084c018 RCX: ffff88046ef1a700
RDX: 0000000000001ad9 RSI: 000000006b6b6b6b RDI: ffff88038084c018
RBP: ffffc90002687b40 R08: 0000000000140000 R09: 0000000000000000
R10: ffffc90002687af8 R11: ffffffffa03da948 R12: ffff8804693cc3e8
R13: ffff880381058958 R14: ffff8804693cc400 R15: ffff88040d775fd8
FS:  00007f176347b100(0000) GS:ffff88046ef00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000001a730 CR3: 0000000346eeb000 CR4: 00000000001406e0
Call Trace:
 do_raw_spin_lock+0xb2/0xc0
 _raw_spin_lock_irq+0x3d/0x50
 ib_uverbs_release_uevent+0x38/0xd0 [ib_uverbs]
 ib_uverbs_cleanup_ucontext+0x1f7/0x620 [ib_uverbs]
 ib_uverbs_remove_one+0x17e/0x300 [ib_uverbs]
 ib_unregister_device+0xe9/0x190 [ib_core]
 mlx4_ib_remove+0x6d/0x250 [mlx4_ib]
 mlx4_remove_device+0xa0/0xc0 [mlx4_core]
 mlx4_unregister_device+0x8f/0x140 [mlx4_core]
 mlx4_change_port_types+0x60/0x140 [mlx4_core]
 __set_port_type+0x15e/0x1d0 [mlx4_core]
 set_port_type+0x7a/0xf0 [mlx4_core]
 dev_attr_store+0x18/0x30
 sysfs_kf_write+0x45/0x60
 kernfs_fop_write+0x13c/0x1c0
 __vfs_write+0x28/0x140
 vfs_write+0xc8/0x1e0
 SyS_write+0x49/0xa0
 entry_SYSCALL_64_fastpath+0x18/0xad
RIP: 0033:0x7f1762b65500
RSP: 002b:00007ffc3600f7e8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: ffffffff810bf89f RCX: 00007f1762b65500
RDX: 0000000000000003 RSI: 00000000007e1b00 RDI: 0000000000000001
RBP: 0000000000000002 R08: 00007f1762e27740 R09: 00007f176347b100
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000007c99e0
R13: 0000000000000002 R14: 0000000000000000 R15: 0000000000000002

(gdb) list *(ib_uverbs_release_uevent+0x38)
0x1978 is in ib_uverbs_release_uevent
(drivers/infiniband/core/uverbs_main.c:210).
205                                   struct ib_uevent_object *uobj)
206     {
207             struct ib_uverbs_event *evt, *tmp;
208
209             spin_lock_irq(&file->async_file->lock);
210             list_for_each_entry_safe(evt, tmp, &uobj->event_list, obj_list)
{
211                     list_del(&evt->list);
212                     kfree(evt);
213             }
214             spin_unlock_irq(&file->async_file->lock);

(gdb) list *(queued_spin_lock_slowpath+0xf2)
0xffffffff810c5d42 is in queued_spin_lock_slowpath
(./include/linux/compiler.h:283).
278     {
279             switch (size) {
280             case 1: *(volatile __u8 *)p = *(__u8 *)res; break;
281             case 2: *(volatile __u16 *)p = *(__u16 *)res; break;
282             case 4: *(volatile __u32 *)p = *(__u32 *)res; break;
283             case 8: *(volatile __u64 *)p = *(__u64 *)res; break;
284             default:
285                     barrier();
286                     __builtin_memcpy((void *)p, (const void *)res, size);
287                     barrier();

(gdb) disas queued_spin_lock_slowpath                 
Dump of assembler code for function queued_spin_lock_slowpath:
   0xffffffff810c5c50 <+0>:     callq  0xffffffff816a7080 <__fentry__>
   0xffffffff810c5c55 <+5>:     push   %rbp
   0xffffffff810c5c56 <+6>:     cmp    $0x100,%esi
   0xffffffff810c5c5c <+12>:    mov    %rsp,%rbp
   0xffffffff810c5c5f <+15>:    je     0xffffffff810c5cff
<queued_spin_lock_slowpath+175>
   0xffffffff810c5c65 <+21>:    mov    $0x101,%r8d
   0xffffffff810c5c6b <+27>:    mov    $0x1,%ecx
   0xffffffff810c5c70 <+32>:    jmp    0xffffffff810c5c8b
<queued_spin_lock_slowpath+59>
   0xffffffff810c5c72 <+34>:    cmp    $0x1,%esi
   0xffffffff810c5c75 <+37>:    mov    %ecx,%edx
   0xffffffff810c5c77 <+39>:    mov    %esi,%eax
   0xffffffff810c5c79 <+41>:    cmove  %r8d,%edx
   0xffffffff810c5c7d <+45>:    lock cmpxchg %edx,(%rdi)
   0xffffffff810c5c81 <+49>:    cmp    %eax,%esi
   0xffffffff810c5c83 <+51>:    je     0xffffffff810c5da2
<queued_spin_lock_slowpath+338>
   0xffffffff810c5c89 <+57>:    mov    %eax,%esi
   0xffffffff810c5c8b <+59>:    test   $0xffffff00,%esi
   0xffffffff810c5c91 <+65>:    je     0xffffffff810c5c72
<queued_spin_lock_slowpath+34>
   0xffffffff810c5c93 <+67>:    mov    $0x1a700,%rcx
   0xffffffff810c5c9a <+74>:    add    %gs:0x7ef4448e(%rip),%rcx        #
0xa130 <this_cpu_off>
   0xffffffff810c5ca2 <+82>:    movslq 0xc(%rcx),%rax
   0xffffffff810c5ca6 <+86>:    lea    0x1(%rax),%edx
   0xffffffff810c5ca9 <+89>:    mov    %edx,0xc(%rcx)
   0xffffffff810c5cac <+92>:    mov    %gs:0x7ef44475(%rip),%edx        #
0xa128 <cpu_number>
   0xffffffff810c5cb3 <+99>:    cmp    $0x3,%eax
   0xffffffff810c5cb6 <+102>:   jg     0xffffffff810c5dcf
<queued_spin_lock_slowpath+383>
   0xffffffff810c5cbc <+108>:   mov    %eax,%r8d
   0xffffffff810c5cbf <+111>:   shl    $0x4,%rax
   0xffffffff810c5cc3 <+115>:   add    $0x1,%edx
   0xffffffff810c5cc6 <+118>:   shl    $0x12,%edx
   0xffffffff810c5cc9 <+121>:   add    %rax,%rcx
   0xffffffff810c5ccc <+124>:   shl    $0x10,%r8d
   0xffffffff810c5cd0 <+128>:   movl   $0x0,0x8(%rcx)
   0xffffffff810c5cd7 <+135>:   or     %edx,%r8d
   0xffffffff810c5cda <+138>:   movq   $0x0,(%rcx)
   0xffffffff810c5ce1 <+145>:   mov    (%rdi),%eax
   0xffffffff810c5ce3 <+147>:   test   %eax,%eax
   0xffffffff810c5ce5 <+149>:   jne    0xffffffff810c5d0e
<queued_spin_lock_slowpath+190>
   0xffffffff810c5ce7 <+151>:   mov    $0x1,%edx
   0xffffffff810c5cec <+156>:   lock cmpxchg %edx,(%rdi)
   0xffffffff810c5cf0 <+160>:   test   %eax,%eax
   0xffffffff810c5cf2 <+162>:   jne    0xffffffff810c5d0e
<queued_spin_lock_slowpath+190>
   0xffffffff810c5cf4 <+164>:   decl   %gs:0x7ef54a11(%rip)        # 0x1a70c
<mcs_nodes+12>
   0xffffffff810c5cfb <+171>:   pop    %rbp
   0xffffffff810c5cfc <+172>:   retq   
   0xffffffff810c5cfd <+173>:   pause  
   0xffffffff810c5cff <+175>:   mov    (%rdi),%esi
   0xffffffff810c5d01 <+177>:   cmp    $0x100,%esi
   0xffffffff810c5d07 <+183>:   je     0xffffffff810c5cfd
<queued_spin_lock_slowpath+173>
   0xffffffff810c5d09 <+185>:   jmpq   0xffffffff810c5c65
<queued_spin_lock_slowpath+21>
   0xffffffff810c5d0e <+190>:   mov    %r8d,%eax
   0xffffffff810c5d11 <+193>:   shr    $0x10,%eax
   0xffffffff810c5d14 <+196>:   xchg   %ax,0x2(%rdi)
   0xffffffff810c5d18 <+200>:   mov    %eax,%edx
   0xffffffff810c5d1a <+202>:   xor    %r9d,%r9d
   0xffffffff810c5d1d <+205>:   shl    $0x10,%edx
   0xffffffff810c5d20 <+208>:   test   %edx,%edx
   0xffffffff810c5d22 <+210>:   je     0xffffffff810c5d65
<queued_spin_lock_slowpath+277>
   0xffffffff810c5d24 <+212>:   shr    $0x12,%edx
   0xffffffff810c5d27 <+215>:   and    $0x3,%eax
   0xffffffff810c5d2a <+218>:   sub    $0x1,%edx
   0xffffffff810c5d2d <+221>:   shl    $0x4,%rax
   0xffffffff810c5d31 <+225>:   movslq %edx,%rdx
   0xffffffff810c5d34 <+228>:   add    $0x1a700,%rax
   0xffffffff810c5d3a <+234>:   add    -0x7e5c5c20(,%rdx,8),%rax
   0xffffffff810c5d42 <+242>:   mov    %rcx,(%rax)
   0xffffffff810c5d45 <+245>:   mov    0x8(%rcx),%eax
   0xffffffff810c5d48 <+248>:   test   %eax,%eax
   0xffffffff810c5d4a <+250>:   jne    0xffffffff810c5d55
<queued_spin_lock_slowpath+261>

-- 
You are receiving this mail because:
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
