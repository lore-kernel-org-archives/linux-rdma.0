From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: krping problem on 4.15-rc4
Date: Fri, 19 Jan 2018 09:53:40 -0600
Message-ID: <00c601d3913d$acfef920$06fceb60$@opengridcomputing.com>
References: <00ff01d38a4f$1a979eb0$4fc6dc10$@opengridcomputing.com> <CAN-5tyEwdSOiAk04xjfazxBqwkkTiCjr2dVcCoYLQJw8f37U=w@mail.gmail.com> <017d01d38b14$cbe95670$63bc0350$@opengridcomputing.com> <CAN-5tyGq=hmXY9HZYXpfaytOUV=gb0fri69gj69WKbbYtW3nTQ@mail.gmail.com> <006d01d38c02$793de8c0$6bb9ba40$@opengridcomputing.com> <CAN-5tyG9ZsaKZs3ayfFfuy7o25DrXR2yWmwUvLdNutJ1SbEg1w@mail.gmail.com> <CAN-5tyFSYWaTPVdq=99Yr9XwnULyf4tw06roZys=rtR0F3x03g@mail.gmail.com> <1516223013.3403.285.camel@redhat.com> <CAN-5tyFM_Noj5n-BW+BMa-0VXBWnUVWU2JkiP2f5JBpZoA6YcQ@mail.gmail.com> <CAN-5tyGxnd0WnvgxEpNpZ5fG6u2JZs=Wg0fEvt8EaNLHckvx0A@mail.gmail.com> <20180119110852.GB1393@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180119110852.GB1393-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, 'Olga Kornievskaia' <aglo-63aXycvo3TyHXe+LvDLADg@public.gmane.org>
Cc: 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> > >>> > > Not sure.  But it does seem to be tied to that specific machine.
> Question:  Is an IOMMU enabled on that system?
> > >>> >
> > >>> > IOMMU (Inter's VT-d) is enabled in BIOS (on both machines).
> > >>> >
> > >>> > >  Perhaps that is exposing a dma mapping problem with krping?
> > >>>
> > >>> I have replaces the CX-5 card with another one and I no longer see
the
> > >>> krping problem.  I think it speaks that it's a card issue...
> > >>
> > >> Check the firmware on the bad card.  Lots of issues disappear if you
> > >> have older firmware and update to the latest.
> > >
> > > That's a valid point. A check of firmware versions is needed. At the
> > > time of the problem, I believe I had two machines that each had same
> > > firmware versions. After card replacement, the replacement card
> > > displays newer firmware.
> >
> > I have upgraded the firmware on both machines involved to the latest
> > available firmware for the card and now I'm in the situation where
> > krping does not work on either machine --- when either of them is a
> > server it fails with the same information in the var log messages:
> 
> Doesn't it mean that the issue in FW?
> 

Is still possible that krping has some dma mapping bug that wasn't detected
by older FW, and now is being detected by the new FW?


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
