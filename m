From: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH rdma-core 1/2] suse: Add spec file for SUSE
Date: Mon, 28 Aug 2017 11:36:22 +0200
Message-ID: <4e542580-eadd-f655-f09e-a0502a213600@suse.de>
References: <abf2bc82-824b-a1d9-bc6b-a3a77045d633@suse.de>
 <20170827214704.GC14542@obsidianresearch.com>
 <ecddc225-0dc5-c51f-535b-c2bee252d5ed@suse.de>
 <20170828060758.GD12880@mtr-leonro.local>
 <86a21008-c993-de29-2cb9-845af14c4cd5@suse.de>
 <20170828090537.GG12880@mtr-leonro.local>
 <0754696d-42d5-5083-8ed0-435ab3f189de@suse.de>
 <20170828092406.GH12880@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170828092406.GH12880-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



Le 28/08/2017 à 11:24, Leon Romanovsky a écrit :
> On Mon, Aug 28, 2017 at 11:13:07AM +0200, Nicolas Morey-Chaisemartin wrote:
>>
>> Le 28/08/2017 à 11:05, Leon Romanovsky a écrit :
>>> On Mon, Aug 28, 2017 at 10:17:50AM +0200, Nicolas Morey-Chaisemartin wrote:
>>>> Le 28/08/2017 à 08:07, Leon Romanovsky a écrit :
>>>>> On Mon, Aug 28, 2017 at 07:59:29AM +0200, Nicolas Morey-Chaisemartin wrote: >> >> >> Le 27/08/2017 à 23:47, Jason Gunthorpe a écrit : >>> On Thu, Aug 24, 2017 at 04:49:54PM +0200, Nicolas Morey-Chaisemartin wrote: >>> >>>> +install -D -m0644 redhat/rdma.conf %{buildroot}/%{_sysconfdir}/rdma/rdma.conf >>>> +sed 's%/usr/libexec%/usr/lib%' redhat/rdma.service > %{buildroot}%{_unitdir}/rdma.service >>>> +chmod 0644 %{buildroot}%{_unitdir}/rdma.service >>>> +install -D -m0644 redhat/rdma.sriov-vfs %{buildroot}/%{_sysconfdir}/rdma/sriov-vfs >>>> +install -D -m0644 redhat/rdma.mlx4.conf %{buildroot}/%{_sysconfdir}/rdma/mlx4.conf >>>> +install -D -m0644 redhat/rdma.udev-ipoib-naming.rules %{buildroot}%{_udevrulesdir}/70-persistent-ipoib.rules >>>> +sed 's%/usr/libexec%/usr/lib%g' redhat/rdma
 .modules-setup.sh > %{buildroot}%{dracutlibdir}/modules.d/05rdma/module-setup.sh >>>> +chmod 0755 %{buildroot}%{dracutlibdir}/modules.d/05rdma/module-setup.sh >>>> +install -D -m0644 redhat/rdma.udev-rules %{buildroot}%{_udevrulesdir}/98-rdma.rules >>>> +sed
>>>> 's%/usr/libexec%/usr/lib%g' redhat/rdma.mlx4.sys.modprobe > %{buildroot}%{sysmodprobedir}/50-libmlx4.conf >>>> +chmod 0644 %{buildroot}%{sysmodprobedir}/50-libmlx4.conf >>>> +sed 's%/usr/libexec%/usr/lib%g' redhat/rdma.kernel-init > %{buildroot}%{_libexecdir}/rdma-init-kernel >>>> +chmod 0755 %{buildroot}%{_libexecdir}/rdma-init-kernel >>>> +install -D -m0755 redhat/rdma.sriov-init %{buildroot}%{_libexecdir}/rdma-set-sriov-vf >>>> +install -D -m0644 redhat/rdma.fixup-mtrr.awk %{buildroot}%{_libexecdir}/rdma-fixup-mtrr.awk >>>> +install -D -m0755 redhat/rdma.mlx4-setup.sh %{buildroot}%{_libexecdir}/mlx4-setup.sh >>> Going forward suse may not want to include this boot stuff from RH, >>> unless historical versions of suse used it or something similar. The >>> new cross-distro stuff in k
 ernel-boot basically does the same thing. >>> >>> I'm hoping RH will discontinue their version in newer releases. >>> >>> Jason >> Do you mean that all these should not be used anymore? > > I
>>>> think so, from the spotted immediately - "fixup-mtrr" - is not needed > for sure. > >> The udev rules and the few new services are now sufficient ? > > This was the intention. > > I tried dropping those files from the package and it does not seem to be fully functionnal yet.
>>>> I'm running and a very old Mellanox card (mthca driver) and the rdma-load-modules@infiniband is not started. Thus ipoib and umad modules are missing.
>>>>
>>> Can you please resend?
>>> It is not readable.
>>>
>>> Thanks
>>>
>> Sorry. The latest Thunderbird seems to screw up things regularly now :s
>> The current udev system does not load the infiniband modules (ipoib, umad) for old mthca cards.
> Among us, Doug is the last who has such cards.
We also have a couple of them at SUSE lab for testing. Even if this HW is old and unsupported, the fix is simple enough to be worth applying IMHO :)

Nicolas

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
