From: Olga Kornievskaia <aglo-63aXycvo3TyHXe+LvDLADg@public.gmane.org>
Subject: Re: krping problem on 4.15-rc4
Date: Wed, 17 Jan 2018 17:03:16 -0500
Message-ID: <CAN-5tyFM_Noj5n-BW+BMa-0VXBWnUVWU2JkiP2f5JBpZoA6YcQ@mail.gmail.com>
References: <CAN-5tyH1HO7yzzQLyb5z5Pq=OrHnKzmCrR2MffLguqsEA-mwWg@mail.gmail.com>
 <00ff01d38a4f$1a979eb0$4fc6dc10$@opengridcomputing.com> <CAN-5tyEwdSOiAk04xjfazxBqwkkTiCjr2dVcCoYLQJw8f37U=w@mail.gmail.com>
 <017d01d38b14$cbe95670$63bc0350$@opengridcomputing.com> <CAN-5tyGq=hmXY9HZYXpfaytOUV=gb0fri69gj69WKbbYtW3nTQ@mail.gmail.com>
 <006d01d38c02$793de8c0$6bb9ba40$@opengridcomputing.com> <CAN-5tyG9ZsaKZs3ayfFfuy7o25DrXR2yWmwUvLdNutJ1SbEg1w@mail.gmail.com>
 <CAN-5tyFSYWaTPVdq=99Yr9XwnULyf4tw06roZys=rtR0F3x03g@mail.gmail.com> <1516223013.3403.285.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1516223013.3403.285.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 17, 2018 at 4:03 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Tue, 2018-01-16 at 16:14 -0500, Olga Kornievskaia wrote:
>> On Tue, Jan 16, 2018 at 2:50 PM, Olga Kornievskaia <aglo-63aXycvo3TyHXe+LvDLADg@public.gmane.org> wrote:
>> > On Fri, Jan 12, 2018 at 7:07 PM, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> wrote:
>> > > > > Ok.  The memory probably doesn't matter.  Maybe run krping client and
>> > > >
>> > > > server on the same host (to use hw-loopback), and see if it works on both,
>> > > > one, or neither systems when they are both the client and server.
>> > > >
>> > > > Loopback on the original "server" machine produces the same failure.
>> > > > Jan 12 17:05:40 localhost kernel: mlx5_0:dump_cqe:277:(pid 0): dump error
>> > > > cqe
>> > > > Jan 12 17:05:40 localhost kernel: 00000000 00000000 00000000 00000000
>> > > > Jan 12 17:05:40 localhost kernel: 00000000 00000000 00000000 00000000
>> > > > Jan 12 17:05:40 localhost kernel: 00000000 00000000 00000000 00000000
>> > > > Jan 12 17:05:40 localhost kernel: 00000000 93003204 1000017c 0005e1d2
>> > > > Jan 12 17:05:40 localhost kernel: krping: cq completion failed with
>> > > > wr_id 0 status 4 opcode 0 vender_err 32
>> > >
>> > > Can someone from Mellanox comment more on the above CQE error?  What exactly is it tell us?
>> > >
>> > > >
>> > > > What does this means?
>> > >
>> > > Not sure.  But it does seem to be tied to that specific machine.  Question:  Is an IOMMU enabled on that system?
>> >
>> > IOMMU (Inter's VT-d) is enabled in BIOS (on both machines).
>> >
>> > >  Perhaps that is exposing a dma mapping problem with krping?
>>
>> I have replaces the CX-5 card with another one and I no longer see the
>> krping problem.  I think it speaks that it's a card issue...
>
> Check the firmware on the bad card.  Lots of issues disappear if you
> have older firmware and update to the latest.

That's a valid point. A check of firmware versions is needed. At the
time of the problem, I believe I had two machines that each had same
firmware versions. After card replacement, the replacement card
displays newer firmware.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
