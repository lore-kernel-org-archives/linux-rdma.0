From: Mathis GAVILLON <jbiboche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Fwd: Error message when trying to use Infiniband virtual
 functions in virtual machine
Date: Tue, 5 Feb 2013 11:32:30 +0100
Message-ID: <CAOoYFkEnzYwPDjka+GGXeXt2xkGhX7qwAptGUvUJChgDEjRBGw@mail.gmail.com>
References: <CAOoYFkGrsWKGaFcNAQQnkks2Ku6O8xkPk=8BGQfRR74QhRU=VA@mail.gmail.com>
	<201301291644.35771.jackm@dev.mellanox.co.il>
	<CAOoYFkErXNxSBrQC_spMwcEiVmOpkzqQwuTQPOwO70bigsgYkQ@mail.gmail.com>
	<201302031040.20906.jackm@dev.mellanox.co.il>
	<CAOoYFkHnrty9Nh294y94bWx2PEXHxk8_cVbYbPJ+=jLgf4m+0A@mail.gmail.com>
	<B855DA7245737D4B83EDD9C0B7698E655952F564@MTLDAG02.mtl.com>
	<1359991471.11144.396.camel@bling.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1359991471.11144.396.camel-xdHQ/5r00wBBDLzU/O5InQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Alex, Or, Jack,

I've just finished to install qemu 1.3.1 and all is working well. IRQ
error has disappeared and an IB interface is know available in the
virtual machine.

Thank's so much to all of you for all of your answers

Mathis

2013/2/4 Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> On Mon, 2013-02-04 at 11:23 +0000, Or Gerlitz wrote:
>> > Should I try to launch VM in an older version of qemu-kvm ?
>> > dmesg when using qemu-kvm 1.2.2-6 :
>>
>> You need to use a release/drop of qemu which has these fixes,
>>
>> http://marc.info/?l=qemu-devel&m=135835580814935&w=2
>> http://marc.info/?l=qemu-devel&m=135836502119460&w=2
>>
>> Alex, what stable branch/release would you recommend to use?
>
> These are available in the qemu 1.3.1 stable release
>
> http://lists.gnu.org/archive/html/qemu-devel/2013-01/msg05403.html
>
> And they're in the current development tree which is stabilizing for the
> 1.4.0 release.  Thanks,
>
> Alex
>
>> ________________________________________
>> From: Mathis GAVILLON [jbiboche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
>> Sent: 04 February 2013 11:42
>> To: Jack Morgenstein
>> Cc: Or Gerlitz
>> Subject: Re: Fwd: Error message when trying to use Infiniband virtual functions in virtual machine
>>
>> The solution you proposed hasn't changed anything. The error message
>> in the VM and "Disabling IRQ #16" is already present in log files.
>> Should I try to launch VM in an older version of qemu-kvm ?
>>
>> dmesg when using qemu-kvm 1.2.2-6 :
>>
>> [ 1914.152816] pci 0000:82:00.1: enabling device (0000 -> 0002)
>> [ 1914.156091] mlx4_core 0000:82:00.0: FLR event for slave: 1
>> [ 1914.156101] mlx4_core 0000:82:00.0: mlx4_handle_slave_flr
>> [ 1914.156103] mlx4_core 0000:82:00.0: mlx4_handle_slave_flr: clean slave: 1
>> [ 1914.878353] assign device 0:82:0.1
>> [ 1915.080617] mlx4_core 0000:82:00.0: FLR event for slave: 1
>> [ 1915.080651] mlx4_core 0000:82:00.0: mlx4_handle_slave_flr
>> [ 1915.080652] mlx4_core 0000:82:00.0: mlx4_handle_slave_flr: clean slave: 1
>> [ 1932.546300] mlx4_core 0000:82:00.0: Received reset from slave:1
>> [ 1932.559015] pci 0000:82:00.1: irq 178 for MSI/MSI-X
>> [ 1932.576928] pci 0000:82:00.1: irq 178 for MSI/MSI-X
>> [ 1932.576951] pci 0000:82:00.1: irq 179 for MSI/MSI-X
>> [ 1933.017996] irq 16: nobody cared (try booting with the "irqpoll" option)
>> [ 1933.018000] Pid: 0, comm: swapper/3 Not tainted 3.8.0-rc2 #1
>> [ 1933.018001] Call Trace:
>> [ 1933.018002]  <IRQ>  [<ffffffff810dc41d>] __report_bad_irq+0x3d/0xe0
>> [ 1933.018015]  [<ffffffff810dc713>] note_interrupt+0x1a3/0x1f0
>> [ 1933.018020]  [<ffffffff814362d0>] ? userspace_cpufreq_notifier+0x90/0x90
>> [ 1933.018023]  [<ffffffff810d9e69>] handle_irq_event_percpu+0xb9/0x200
>> [ 1933.018026]  [<ffffffff814362d0>] ? userspace_cpufreq_notifier+0x90/0x90
>> [ 1933.018029]  [<ffffffff810d9ff2>] handle_irq_event+0x42/0x70
>> [ 1933.018031]  [<ffffffff810dd259>] handle_fasteoi_irq+0x59/0x100
>> [ 1933.018036]  [<ffffffff8101616f>] handle_irq+0xbf/0x150
>> [ 1933.018041]  [<ffffffff8155b792>] ? __atomic_notifier_call_chain+0x12/0x20
>> [ 1933.018044]  [<ffffffff8155b7b6>] ? atomic_notifier_call_chain+0x16/0x20
>> [ 1933.018047]  [<ffffffff8156188a>] do_IRQ+0x5a/0xe0
>> [ 1933.018050]  [<ffffffff81557aad>] common_interrupt+0x6d/0x6d
>> [ 1933.018051]  <EOI>  [<ffffffff81436d00>] ? cpuidle_wrap_enter+0x50/0xa0
>> [ 1933.018057]  [<ffffffff81436cf9>] ? cpuidle_wrap_enter+0x49/0xa0
>> [ 1933.018060]  [<ffffffff81436d60>] cpuidle_enter_tk+0x10/0x20
>> [ 1933.018063]  [<ffffffff8143698b>] cpuidle_idle_call+0xbb/0x280
>> [ 1933.018067]  [<ffffffff8101d2ef>] cpu_idle+0xaf/0x120
>> [ 1933.018071]  [<ffffffff81544bb9>] start_secondary+0x255/0x257
>> [ 1933.018072] handlers:
>> [ 1933.018075] [<ffffffff813cea90>] usb_hcd_irq
>> [ 1933.018077] Disabling IRQ #16
>> [ 1942.678990] mlx4_core 0000:82:00.0: Received reset from slave:1
>>
>> dmesg when using qemu-kvm 1.3.0-5 :
>>
>> [  181.886165] pci 0000:82:00.1: enabling device (0000 -> 0002)
>> [  181.889480] mlx4_core 0000:82:00.0: FLR event for slave: 1
>> [  181.889517] mlx4_core 0000:82:00.0: mlx4_handle_slave_flr
>> [  181.889519] mlx4_core 0000:82:00.0: mlx4_handle_slave_flr: clean slave: 1
>> [  182.622378] assign device 0:82:0.1
>> [  182.798342] mlx4_core 0000:82:00.0: FLR event for slave: 1
>> [  182.798352] mlx4_core 0000:82:00.0: mlx4_handle_slave_flr
>> [  182.798354] mlx4_core 0000:82:00.0: mlx4_handle_slave_flr: clean slave: 1
>> [  202.515121] mlx4_core 0000:82:00.0: Received reset from slave:1
>> [  202.527857] pci 0000:82:00.1: irq 178 for MSI/MSI-X
>> [  202.549725] pci 0000:82:00.1: irq 178 for MSI/MSI-X
>> [  202.549740] pci 0000:82:00.1: irq 179 for MSI/MSI-X
>> [  202.991521] irq 16: nobody cared (try booting with the "irqpoll" option)
>> [  202.991526] Pid: 0, comm: swapper/3 Not tainted 3.8.0-rc2 #1
>> [  202.991527] Call Trace:
>> [  202.991528]  <IRQ>  [<ffffffff810dc41d>] __report_bad_irq+0x3d/0xe0
>> [  202.991541]  [<ffffffff810dc713>] note_interrupt+0x1a3/0x1f0
>> [  202.991546]  [<ffffffff814362d0>] ? userspace_cpufreq_notifier+0x90/0x90
>> [  202.991550]  [<ffffffff810d9e69>] handle_irq_event_percpu+0xb9/0x200
>> [  202.991553]  [<ffffffff814362d0>] ? userspace_cpufreq_notifier+0x90/0x90
>> [  202.991555]  [<ffffffff810d9ff2>] handle_irq_event+0x42/0x70
>> [  202.991558]  [<ffffffff810dd259>] handle_fasteoi_irq+0x59/0x100
>> [  202.991562]  [<ffffffff8101616f>] handle_irq+0xbf/0x150
>> [  202.991567]  [<ffffffff8155b792>] ? __atomic_notifier_call_chain+0x12/0x20
>> [  202.991570]  [<ffffffff8155b7b6>] ? atomic_notifier_call_chain+0x16/0x20
>> [  202.991574]  [<ffffffff8156188a>] do_IRQ+0x5a/0xe0
>> [  202.991577]  [<ffffffff81557aad>] common_interrupt+0x6d/0x6d
>> [  202.991577]  <EOI>  [<ffffffff81436d00>] ? cpuidle_wrap_enter+0x50/0xa0
>> [  202.991584]  [<ffffffff81436cf9>] ? cpuidle_wrap_enter+0x49/0xa0
>> [  202.991587]  [<ffffffff81436d60>] cpuidle_enter_tk+0x10/0x20
>> [  202.991589]  [<ffffffff8143698b>] cpuidle_idle_call+0xbb/0x280
>> [  202.991593]  [<ffffffff8101d2ef>] cpu_idle+0xaf/0x120
>> [  202.991597]  [<ffffffff81544bb9>] start_secondary+0x255/0x257
>> [  202.991598] handlers:
>> [  202.991602] [<ffffffff813cea90>] usb_hcd_irq
>> [  202.991603] Disabling IRQ #16
>> [  212.669908] mlx4_core 0000:82:00.0: Received reset from slave:1
>>
>> Thanks
>
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
