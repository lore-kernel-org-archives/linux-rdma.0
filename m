From: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [RFC v2 for accelerated IPoIB 00/6] Enhanced mode for IPoIB driver
Date: Tue, 28 Mar 2017 14:40:21 +0300
Message-ID: <CAAk-MO8Z7wKGFU5empgHGpN73cGMkKMi+ijnTHpfXBD5oZ+cGQ@mail.gmail.com>
References: <1490036908-12528-1-git-send-email-erezsh@mellanox.com>
 <20170320205927.GA17225@obsidianresearch.com> <20170321114955.GB2079@mtr-leonro.local>
 <20170321161530.GB22216@obsidianresearch.com> <20170321164952.GE2079@mtr-leonro.local>
 <CAAk-MO_KEV9MA5Dcaz8SZagMeC4hQX456Cu8To-YRBNMeNu3pg@mail.gmail.com>
 <20170322165238.GA26589@obsidianresearch.com> <CAAk-MO_7LVUQS_8+h9shFEXkjT6NHkzXeYRH+_8Wcjr0P+dHAw@mail.gmail.com>
 <20170326204237.GB3113@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170326204237.GB3113-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Mar 26, 2017 at 11:42 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Sun, Mar 26, 2017 at 07:17:13PM +0300, Erez Shitrit wrote:
>
>> > be computed once instead of computed for every split packet. The
>> > downside here is that it may be very complicated to store a kref in a
>> > skb pseudo header and properly unref it at all the right times..
>>
>> It is an optimization, and still we need to get the ah even at the
>> middle of GSO, for each skb, or to keep it somewhere, also will need
>> to keep more space in the skb, more processing.
>
> GSO is done in a way where the pseudo header is retained but not
> recomputed for every fragment, much like for ethernet.
>
> Does mlx5 even need a 'AH'? Maybe allowing the driver to provide some
> bytes in the pseudo header that match the HW SQE is an overall more
> efficient direction.

For mlx5/mlx4, the details from the ah are required, (in order to
build the datagram segment in the wqe(, but the ref count is seamless
since the ah is not a hw resource,  I can put that instead of the
pseudo header in the driver start_xmit
need to check if it pays with performance degradation.
will check and update.

>
>> > The other is to factor out the AH extraction from ipoib_start_xmit
>> > into a helper function and have all the rn drivers call it to get the
>> > AH.
>>
>> We will pay with performance degradation for each send.
>
> Eh? Having ndo->ipoib->driver or ndo->driver->ipoib as a call chain
> doesn't really matter one bit.

I meant that the extra call is time consuming, if we need one more
function (to extract the ah) that needs to be exported.

Anyway, will try with the first option.

>
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
