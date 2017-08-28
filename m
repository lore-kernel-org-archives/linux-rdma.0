From: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH rdma-core] suse: switch fully to the new udev mechanism
Date: Mon, 28 Aug 2017 17:23:25 +0200
Message-ID: <b4b35cf1-ed07-dbee-37cc-15c00480ad04@suse.de>
References: <20170827214704.GC14542@obsidianresearch.com>
 <71835edf-cb2a-d4f8-627e-0f60ee772fb7@suse.de>
 <20170828151609.GA7867@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170828151609.GA7867-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



Le 28/08/2017 à 17:16, Jason Gunthorpe a écrit :
> On Mon, Aug 28, 2017 at 05:05:33PM +0200, Nicolas Morey-Chaisemartin wrote:
>
>> -sed 's%/usr/libexec%/usr/lib%g' redhat/rdma.modules-setup.sh > %{buildroot}%{dracutlibdir}/modules.d/05rdma/module-setup.sh
>> -chmod 0755 %{buildroot}%{dracutlibdir}/modules.d/05rdma/module-setup.sh
> You probably still need something dracut related.
>
> At a minimum you have to address the problem we saw in Debian: mlx5
> and mlx4 need to have their rdma modules include in the initrd if
> their core modules are included. (eg anything request_module'd from
> the initrd must be present)
>
> You may need to do more if you intend to support boot over ipoib, srp,
> nfs-rdma, etc - I think the RH scripts aim to support.
>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
These were in your mail so I assumed they could be dropped :)
I'll keep the dracut stuff then.

Nicolas
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
