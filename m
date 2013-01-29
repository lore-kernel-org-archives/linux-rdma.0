From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: Fwd: Error message when trying to use Infiniband virtual functions in virtual machine
Date: Tue, 29 Jan 2013 16:33:04 +0200
Message-ID: <201301291633.04975.jackm@dev.mellanox.co.il>
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
> guest (is it necessary for this last one ?)

Yes, it is necessary.  Without that checked, I noticed that SRIOV did not work properly.

-Jack
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
