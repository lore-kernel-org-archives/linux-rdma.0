From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: mlx4 fix for 36-bit bus addresses on 32-bit arch
Date: Fri, 14 Jan 2011 13:26:33 -0800
Message-ID: <adawrm718ja.fsf@cisco.com>
References: <ig5vl1$j0$1@dough.gmane.org> <adafwt06puj.fsf@cisco.com>
	<4D2D5FAD.6030508@cadence.com> <adahbde57r7.fsf_-_@cisco.com>
	<20110114130903.GA29706@mtldesk30>
	<20110114172721.GB16535@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110114172721.GB16535-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> (Jason Gunthorpe's
	message of "Fri, 14 Jan 2011 10:27:21 -0700")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "J.L. Burr" <jlburr-vna1KIf7WgpBDgjK7y7TUQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > > Regardless of whether what I say above is correct or not, wouldn't it
 > > be nicer to to define pfn as either u64 or phys_addr_t and avoid the
 > > casting?
 > 
 > Good point, the pfn must be stored as phys_addr_t too, otherwise you
 > only support a 44 bit physical address space before truncatation
 > occures.

Not sure I agree at the moment... eg remap_pfn_range takes unsigned
long.  So I don't think things will really work on a 32-bit arch with >
44 bit bus addresses for lots of other reasons.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
