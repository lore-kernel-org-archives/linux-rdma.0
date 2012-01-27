From: Sven Breuner <sven.breuner-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
Subject: Re: [PATCH] core/verb.c: fix kernel panic: always initialize struct
 ib_qp *qp->usecnt
Date: Fri, 27 Jan 2012 19:49:45 +0100
Message-ID: <4F22F1C9.3090801@itwm.fraunhofer.de>
References: <20120119194641.1391553.39048.stgit@localhost.localdomain> <1828884A29C6694DAF28B7E6B8A823732DC0C33E@ORSMSX106.amr.corp.intel.com> <4F1992F6.9070103@itwm.fraunhofer.de> <CAL1RGDWSh3HpVY5dui549EoqhzTYaSnsCPGdEU+hPZ9NWx6ttw@mail.gmail.com> <CAL1RGDW=XfCd3aCmB0mE1WcOUeDj=17=s2K0A3zpFmBF6Rg_Rg@mail.gmail.com> <4F22CF82.2060606@itwm.fraunhofer.de> <CAL1RGDXXYG48d2P0h4G+z4W8HebjrQ7HTWyx5FqgB0_2OqC4Ng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDXXYG48d2P0h4G+z4W8HebjrQ7HTWyx5FqgB0_2OqC4Ng-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: public-linux-rdma-u79uwXL29TY76Z2rM5mHXA-XMD5yJDbdMReXY1tMh2IBg-1dZseelyfdZg9hUCZPvPmw@public.gmane.org, Bernd Schubert <public-public-bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX-1dZseelyfdZg9hUCZPvPmw-1dZseelyfdZg9hUCZPvPmw@public.gmane.org>, "Hefty, Sean" <public-public-sean.hefty-ral2JQCrhuEAvxtiuMwx3w-1dZseelyfdZg9hUCZPvPmw-1dZseelyfdZg9hUCZPvPmw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

Roland Dreier wrote on 01/27/2012 06:20 PM:
> I've applied it and will send it to Linus soon.

thanks! Will you also take care of the Linux-stable (3.2.x) backport or 
should I send it for inclusion in Linux-stable?

Best regards,
Sven

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
