From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 07/14] mlx4: Update to use new udma write
 barriers
Date: Tue, 21 Feb 2017 11:14:07 -0700
Message-ID: <20170221181407.GA13138@obsidianresearch.com>
References: <1487272989-8215-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1487272989-8215-8-git-send-email-jgunthorpe@obsidianresearch.com>
 <206559e5-0488-f6d5-c4ec-bf560e0c3ba6@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <206559e5-0488-f6d5-c4ec-bf560e0c3ba6-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Feb 20, 2017 at 07:46:02PM +0200, Yishai Hadas wrote:

> > 	pthread_spin_lock(&qp->sq.lock);
> >
> >+	/* Get all user DMA buffers ready to go */
> >+	udma_to_device_barrier();
> >+
> > 	/* XXX check that state is OK to post send */
> 
> Not clear why do we need here an extra barrier ? what is the future
> optimization that you pointed on ?

Writes to different memory types are not guarenteed to be strongly
ordered. This is narrowly true on x86-64 too apparently.

The purpose of udma_to_device_barrier is to serialize all memory
types.

This allows the follow on code to use the weaker
'udma_ordering_write_barrier' when it knows it is working exclusively
with cached memory.

Eg in an ideal world on x86 udma_to_device_barrier should be SFENCE
and 'udma_ordering_write_barrier' should be compiler_barrier()

Since the barriers have been so ill defined and wonky on x86 other
arches use much stronger barriers than they actually need for each
cases. Eg ARM64 can switch to much weaker barriers.

Since there is no cost on x86-64 to this barrier I would like to leave
it here as it lets us actually optimize the ARM and other barriers. If
you take it out then 'udma_ordering_write_barrier' is forced to be the
strongest barrier on all arches.

> >@@ -478,7 +481,7 @@ out:
> > 		 * Make sure that descriptor is written to memory
> > 		 * before writing to BlueFlame page.
> > 		 */
> >-		wmb();
> >+		mmio_wc_start();
> 
> Why to make this change which affects at least X86_64 ? the data was
> previously written to the host memory so we expect that wmb is
> enough here.

Same as above, writes to different memory types are not strongly
ordered and wmb() is not the right barrier to serialize writes to
DMA'able ctrl with the WC memcpy.

If this is left wrong then again other arches are again required to
adopt the strongest barrier for everything which hurts them.

Even on x86, it is very questionable to not have the SFENCE in that
spot. AFAIK it is not defined to be strongly ordered.

mlx5 has the SFENCE here, for instance.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
