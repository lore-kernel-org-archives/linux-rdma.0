From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next V1 9/9] IB/cma: Join and leave multicast groups
 with IGMP
Date: Tue, 24 Nov 2015 11:15:00 -0700
Message-ID: <20151124181500.GD10391@obsidianresearch.com>
References: <1444925232-13598-1-git-send-email-matanb@mellanox.com>
 <1444925232-13598-10-git-send-email-matanb@mellanox.com>
 <20151123212526.GD6062@obsidianresearch.com>
 <CAG9sBKMUPJ74RLKT54yO-==0gP9nzfrbfWz1Mb_J5VstRQr2OA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAG9sBKMUPJ74RLKT54yO-==0gP9nzfrbfWz1Mb_J5VstRQr2OA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 24, 2015 at 11:41:10AM +0200, Moni Shoua wrote:
> On Mon, Nov 23, 2015 at 11:25 PM, Jason Gunthorpe
> <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> > On Thu, Oct 15, 2015 at 07:07:12PM +0300, Matan Barak wrote:
> >> diff --git a/include/rdma/ib_sa.h b/include/rdma/ib_sa.h
> >> index 0a40ed2..5bea0e8 100644
> >> +++ b/include/rdma/ib_sa.h
> >> @@ -206,6 +206,9 @@ struct ib_sa_mcmember_rec {
> >>       u8           scope;
> >>       u8           join_state;
> >>       int          proxy_join;
> >> +     int          ifindex;
> >> +     struct net  *net;
> >> +     enum ib_gid_type gid_type;
> >>  };
> >
> > This is really gross.
> >
> > Make ib_init_ah_from_mcmember accept a QP and get the above stuff from
> > the QP.
> >
> > Jason
> 
> Which QP is that. You might not have any existing QP when you want to
> create the AH or you might have 10.

roce multicast is only done with the CM and the CM always has a QP.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
