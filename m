From: Chris Blake <chrisrblake93-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: 4.13 ib_mthca NULL pointer dereference with OpenSM
Date: Sun, 12 Nov 2017 17:38:20 -0600
Message-ID: <CALpBJjogf5ONOmMTr9Z8RQ_78aON=_zSSJ+K-_VQyRRXO6vkAQ@mail.gmail.com>
References: <20171030230156.GA4081@ziepe.ca> <VI1PR0502MB300860F7C004ABFB01079F53D15E0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20171031042435.GB7961@ziepe.ca> <e2a2aa84-71ce-36f0-91af-0854b24d4a6a@dev.mellanox.co.il>
 <60de3bab-f294-dd11-bcae-d179115f7c31@mellanox.com> <20171031150901.GA9852@ziepe.ca>
 <20171031151521.GK16127@mtr-leonro.local> <5ab2d58d-8af8-c075-86f0-7010b8316cba@mellanox.com>
 <CALpBJjorS-AK3Ua9UuUnWv33rYqBoeAXF9vsFALTff5Qv3hNSg@mail.gmail.com>
 <fa1abfd0-e9fc-e842-8a21-c214e9dc8e9e@mellanox.com> <20171031192340.GA18578@ziepe.ca>
 <799ce928-2e7c-7f60-951a-3a88544b7510@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <799ce928-2e7c-7f60-951a-3a88544b7510-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 31, 2017 at 2:44 PM, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrot=
e:
> On 10/31/2017 2:23 PM, Jason Gunthorpe wrote:
>> On Tue, Oct 31, 2017 at 12:22 PM, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> =
wrote:
>>
>>> Sounds like the crash is resolved and now you're getting a denial
>>> from a security module.  I looked in the code, it looks like
>> If Chris was hitting that crash it means his security module failed the
>> mad action, as that is the only way to trigger it.
>>
>>> AppArmor doesn't register any callbacks for the ib_* security hooks,
>>> and if no hook is registered it should return 0.  Can you tell me
>>> more about your setup so I can create a reproducer? What OS are you
>>> using? Can you double check that SELinux isn't enabled (see output
>>> of sestatus).
>> Which suggests to me that apparmour is not working properly with the
>> rdma selinux patches??
>
> It seems that way.  I can't explain it looking at the code, I'm trying to=
 reproduce it for debug.
>
>  A point of clarification, the RDMA "SELinux" patches aren't SELinux spec=
ific.  They interact with the LSM, a layer of abstraction between the secur=
ity modules and the rest of the kernel.   Zero or more security modules lik=
e SELinux or AppArmor can implement the security hooks.  The default return=
 value for the hook in question is 0 if no modules implement it.  It doesn'=
t look like AppArmor implements it.
>
>> Jason
>>
>

Hello All,

As a follow up to this issue, I went ahead and installed v4.14-rc8
mainline from http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.14-rc8/
to do some testing. I disabled apparmor via the cmdline (I added
apparmor=3D0 security=3D"") and this seems to have worked:

root@C6100-1-N4:~# cat /proc/cmdline
BOOT_IMAGE=3D/boot/vmlinuz-4.14.0-041400rc8-generic
root=3D/dev/mapper/pve-root ro apparmor=3D0 security=3D quiet
root@C6100-1-N4:~# apparmor_status
apparmor module is loaded.
apparmor filesystem is not mounted.

However, I am still having the issue with up_post_send_mad error:

root@C6100-1-N4:~# uptime
 17:36:30 up 35 min,  1 user,  load average: 0.13, 0.06, 0.01
root@C6100-1-N4:~# dmesg | grep "infiniband mthca0: ib_post_send_mad
error" | wc -l
848

I will admit that I have little knowledge of apparmor, but from the
above if "ib_post_send_mad error" is caused by apparmor as previously
suggested, wouldn't disabling it resolve the issue?

Let me know if you have any other things you would like me to test.

Regards,
Chris Blake
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
