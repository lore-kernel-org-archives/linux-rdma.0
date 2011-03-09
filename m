From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH/libmlx] Set the ibv_wc.opcode even if the wc is an error wc
Date: Wed, 9 Mar 2011 12:14:48 +0100
Message-ID: <AANLkTinsu1xCJr0ROfjGABWg6yHZit27eSFPZgd7GFF2@mail.gmail.com>
References: <20110309042613.GA21606@obsidianresearch.com> <4D771E0F.7040402@mellanox.com>
 <20110309070441.GA25213@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110309070441.GA25213-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 9, 2011 at 8:04 AM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
>
> On Wed, Mar 09, 2011 at 08:28:31AM +0200, Or Gerlitz wrote:
> > On 3/9/2011 6:26 AM, Jason Gunthorpe wrote:
> > >Roland: I don't have a PRM to check if this is correct for the chip, but
> > >it is definately in line with what the IBA expects to happen here.
>
> > Hi Jason, I've been taught that by IBTA if the completion isn't
> > successful then the only valid WC field is the opcode, isn't that
> > correct?
>
> Did you mean wr_id not opcode?
>
> I'd say that 11.4.2.1 supports the view that wr_id and status are the
> only valid fields. However, the whole error handling architecture that
> the WC's fit into is based around the idea that you can go from an
> error WC back to the RQ/SQ that caused the error, correct the
> situation and resume operation. That requires the opcode indicate at
> least SEND vs RECV, and that qp_num be valid.
>
> Frankly, it makes no sense that only wr_id is valid. The wr_id was
> taken from a RQ/SQ, so qp_num and opcode must be knowable.
>
> mlx4 HW can do this right now, it looks to me like QIB does it
> already, donno about mthca. I'd say even if you have the view that
> IBTA says it is not portable, having the information come out is still
> very useful.

If the mlx4 hardware can do this right now then that means that the
mlx4 driver does not pass on the opcode for error completions. The
approach taken in the recently posted ib_srpt code is to encode the
opcode in the wr_id. See also the encode_wr_id(), opcode_from_wr_id()
and idx_from_wr_id() functions.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
