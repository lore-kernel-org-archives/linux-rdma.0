From: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH rdma-core] suse: switch fully to the new udev mechanism
Date: Tue, 29 Aug 2017 09:59:34 +0200
Message-ID: <84031eb6-9ae5-71c6-8ba3-252204c3688d@suse.de>
References: <20170827214704.GC14542@obsidianresearch.com>
 <71835edf-cb2a-d4f8-627e-0f60ee772fb7@suse.de>
 <20170828151609.GA7867@obsidianresearch.com>
 <b4b35cf1-ed07-dbee-37cc-15c00480ad04@suse.de>
 <20170828153146.GC7867@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170828153146.GC7867-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



Le 28/08/2017 à 17:31, Jason Gunthorpe a écrit :
> On Mon, Aug 28, 2017 at 05:23:25PM +0200, Nicolas Morey-Chaisemartin wrote:
>> Le 28/08/2017 ?? 17:16, Jason Gunthorpe a ??crit??:
>>> On Mon, Aug 28, 2017 at 05:05:33PM +0200, Nicolas Morey-Chaisemartin wrote:
>>>
>>>> -sed 's%/usr/libexec%/usr/lib%g' redhat/rdma.modules-setup.sh > %{buildroot}%{dracutlibdir}/modules.d/05rdma/module-setup.sh
>>>> -chmod 0755 %{buildroot}%{dracutlibdir}/modules.d/05rdma/module-setup.sh
>>> You probably still need something dracut related.
>>>
>>> At a minimum you have to address the problem we saw in Debian: mlx5
>>> and mlx4 need to have their rdma modules include in the initrd if
>>> their core modules are included. (eg anything request_module'd from
>>> the initrd must be present)
>>>
>>> You may need to do more if you intend to support boot over ipoib, srp,
>>> nfs-rdma, etc - I think the RH scripts aim to support.
>> These were in your mail so I assumed they could be dropped :)
>> I'll keep the dracut stuff then.
> I was not careful about what I quoted.. Just stuff in that overall area.
>
> The existing dracut script seems to assume other things, so you may
> need a new dracut script. If it is totally general then it can live in
> kernel-boot..
>
> You should also consider if you need the udev triggers, I don't know
> what suse policy is. Look in debian/rdma-core.postinst and others.
>
> Adding them allows the udev rules to trigger on package install and
> makes everything start working without a reboot.


I looked around to all the scripts and I'm going some time to go through all these and decide which we need and which we don't.
Some of those were all upstreamed at once and I'm not sure what the bug they were fixing and if it is still needed.
I contacted Doug on the side. It would make sense to work with Red Hat to migrate to the udev system (vs rdma.service) and "cleanup" those scripts so they can be shared more easily.
This also means this won't be done before v15 is out. We should keep SUSE spec as is (it works) and work on the cleanup for v16.


Nicolas

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
