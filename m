From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH rdma-next 1/6] IB/IPoIB: Introduce RDMA netdev interface
 and IPoIB structs
Date: Tue, 4 Apr 2017 19:48:19 +0000
Message-ID: <1491335298.12081.0.camel@sandisk.com>
References: <20170404191732.31895-1-leon@kernel.org>
         <20170404191732.31895-2-leon@kernel.org>
         <20170404193730.GA10780@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170404193730.GA10780-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Content-ID: <6DC82C30A7800A4C8657457C9DE5ED36-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-04-04 at 13:37 -0600, Jason Gunthorpe wrote:
> On Tue, Apr 04, 2017 at 10:17:27PM +0300, Leon Romanovsky wrote:
> >  struct ib_device {
> > +	/* Do not access @dma_device directly from ULP nor from HW drivers. *=
/
> > +	struct device                *dma_device;
> > +
>=20
> Why is this hunk in this patch? I thought Bart was taking care of this
> topic?

That hunk is already upstream. See also commit 0957c29f78af.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
