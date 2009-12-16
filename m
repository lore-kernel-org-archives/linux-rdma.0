From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: InfiniBand/RDMA merge plans for 2.6.33
Date: Wed, 16 Dec 2009 09:15:09 -0800
Message-ID: <ada1viualia.fsf@roland-alpha.cisco.com>
References: <adaocm1csgb.fsf@roland-alpha.cisco.com>
	<4B28A259.3040909@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B28A259.3040909-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org> (Tziporet Koren's message of
	"Wed, 16 Dec 2009 11:03:21 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


 > >   - mlx4 SR-IOV support.  Again, main problem was my lack of time.  I
 > >     agree in principle with this stuff, just want to be careful that we
 > >     don't turn the mlx4 driver into an unmaintainable mess of "if
 > >     (sriov) something; else something_else" all over.

 > Roland,
 > You have not sent any comments to our patches that were sent few weeks
 > ago on time for 2.6.32 inclusion,
 > and now I am surprised you do not accept them for 2.6.32.
 > I think we still have time to work together and fix your concerns on
 > mlx4 driver.
 > Can you send more concrete comments so we can fix them?

As I said (in the text you quoted), the main problem is my lack of
time.  I want to read the patches over again, and I suspect we will have
one more iteration before they are ready to go.  There does seem to be a
lot of changing from

	/* pv code */

to

	if (sriov) {
		/* sriov code */
	} else {
		/* completely different pv code */
	}

which is to say the least not beautiful.

More broadly there is a problem that I am doing 99% of the code review
for RDMA kernel patches.  Occasionally people get interested in isolated
things, but for the most part the expectation seems to be that I will
review everything, which doesn't scale.

 > Since we have a HW that supports SRIOV and many people are interested
 > in this new technology for KVM thus it is important that we drive it
 > now

If you send a 25-patch series after -rc6, you should expect that there
is a good chance of missing the next merge window.  Sorry -- with the
current process of expecting me to be the only reviewer for nearly
everything, I simply am not going to be able to get through things in time.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
