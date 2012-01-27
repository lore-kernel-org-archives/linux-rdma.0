From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [PATCH] core/verb.c: fix kernel panic: always initialize struct
 ib_qp *qp->usecnt
Date: Fri, 27 Jan 2012 11:09:04 -0800
Message-ID: <CAL1RGDUQR=wk2hh3rx8nALv1sFBG-VJA1cAxDMLq0Kk7SpkFUw@mail.gmail.com>
References: <20120119194641.1391553.39048.stgit@localhost.localdomain>
 <1828884A29C6694DAF28B7E6B8A823732DC0C33E@ORSMSX106.amr.corp.intel.com>
 <4F1992F6.9070103@itwm.fraunhofer.de> <CAL1RGDWSh3HpVY5dui549EoqhzTYaSnsCPGdEU+hPZ9NWx6ttw@mail.gmail.com>
 <CAL1RGDW=XfCd3aCmB0mE1WcOUeDj=17=s2K0A3zpFmBF6Rg_Rg@mail.gmail.com>
 <4F22CF82.2060606@itwm.fraunhofer.de> <CAL1RGDXXYG48d2P0h4G+z4W8HebjrQ7HTWyx5FqgB0_2OqC4Ng@mail.gmail.com>
 <4F22F1C9.3090801@itwm.fraunhofer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F22F1C9.3090801-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sven Breuner <sven.breuner-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, public-linux-rdma-u79uwXL29TY76Z2rM5mHXA-XMD5yJDbdMReXY1tMh2IBg-1dZseelyfdZg9hUCZPvPmw@public.gmane.org, Bernd Schubert <public-public-bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX-1dZseelyfdZg9hUCZPvPmw-1dZseelyfdZg9hUCZPvPmw@public.gmane.org>, "Hefty, Sean" <public-public-sean.hefty-ral2JQCrhuEAvxtiuMwx3w-1dZseelyfdZg9hUCZPvPmw-1dZseelyfdZg9hUCZPvPmw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jan 27, 2012 at 10:49 AM, Sven Breuner
<sven.breuner-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org> wrote:
> thanks! Will you also take care of the Linux-stable (3.2.x) backport or
> should I send it for inclusion in Linux-stable?

I added the CC to stable in the commit so it should happen automatically.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
