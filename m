From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: Fwd: Error message when trying to use Infiniband virtual functions in virtual machine
Date: Tue, 29 Jan 2013 16:44:35 +0200
Message-ID: <201301291644.35771.jackm@dev.mellanox.co.il>
References: <CAOoYFkGrsWKGaFcNAQQnkks2Ku6O8xkPk=8BGQfRR74QhRU=VA@mail.gmail.com> <201301281835.18533.jackm@dev.mellanox.co.il> <CAOoYFkE6YNfEJGJqGmpQTdSxR2Y_9pzkdcnHf_7jjqq57B_Nsw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAOoYFkE6YNfEJGJqGmpQTdSxR2Y_9pzkdcnHf_7jjqq57B_Nsw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathis GAVILLON <jbiboche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tuesday 29 January 2013 15:15, Mathis GAVILLON wrote:
> In fact, one boxe wasn't check in IOMMU submenu (Support for Interrupt
> Remapping (EXPERIMENTAL)). I've recompiled the kernel of the host and
> guest (is it necessary for this last one ?). But the error message is
> already present. Just below, new dmeg log from host and guest O/S
> (mlx4_core loaded with options num_vfs=1 probe_vf=1 debug_level=1 on
> host and debug_level=1 on guest) :
> 
Please do the following:
1. Check the Support for Interrupt Remapping (EXPERIMENTAL) box and recompile/reinstall.
2. set probe_vf=0, so that no vfs will run on the Hypervisor.  That way you will
   see if any VF comes up without the "noise" in /var/log/messages in the Hypervisor generated
   by having one of the VFs run on the Hypervisor.

3. I noticed that you are enabling only a single VF, and that you are having the
   VF come up first on the Hypervisor, then moving it to run on a guest.
   It is better not to do things that way. Best to have it come up cleanly once on
   the guest. (the FLR event in your log results from this move.  The VF gets reset).

   If you must have a VF running on the Hypervisor, use "num_vfs=2 probe_vf=1".
   You will then see Devices ...xx.0, ...xx.1 and ...xx.2 in lspci.  The first VF
   (...xx.1) will be initialized on the Hypervisor.  Attach ...xx.2 to the VM.

-Jack
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
