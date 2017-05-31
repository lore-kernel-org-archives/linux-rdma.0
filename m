From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH rdma-next] Revert "IB/core: Add flow control to the
 portmapper netlink calls"
Date: Wed, 31 May 2017 20:10:31 +0000
Message-ID: <1496261429.2608.15.camel@sandisk.com>
References: <20170529082423.1180-1-leon@kernel.org>
         <20170530212431.GA21008@ssaleem-MOBL4.amr.corp.intel.com>
         <20170531040437.GE5406@mtr-leonro.local>
         <20170531174245.GA16304@ssaleem-MOBL4.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170531174245.GA16304-GOXS9JX10wfOxmVO0tvppfooFf0ArEBIu+b9c/7xato@public.gmane.org>
Content-Language: en-US
Content-ID: <90A1C009B83A134B88B8E9D6C8CE1300-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "leonro-Nfu5REtnQAJWk0Htik3J/w@public.gmane.org" <leonro-Nfu5REtnQAJWk0Htik3J/w@public.gmane.org>, "mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2017-05-31 at 12:42 -0500, Shiraz Saleem wrote:
> > 5. I proposed a solution -> go and fix your user space program.
>=20
> This is a kernel patch you are trying to revert, you are breaking existin=
g
> kernel functionality.  Nothing to do with user space.
>=20
> Bottom line, come up with a solution that will address both port mapper
> functionality and your issue.

Hello Shiraz,

Sorry that this means additional work for you, but I agree with Leon that
user space software should not assume that netlink sockets are a reliable
communication mechanism.

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
