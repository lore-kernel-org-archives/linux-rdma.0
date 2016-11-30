From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH rdma-next 01/10] IB/core: Add raw packet protocol
Date: Wed, 30 Nov 2016 11:27:16 -0600
Message-ID: <01e501d24b2e$ff2a3260$fd7e9720$@opengridcomputing.com>
References: <1480258296-27032-1-git-send-email-leon@kernel.org> <1480258296-27032-2-git-send-email-leon@kernel.org> <20161128170056.GC28381@obsidianresearch.com> <05bd01d2499a$1c75f750$5561e5f0$@opengridcomputing.com> <cfdf28c6-4715-28d4-7da6-453fb6794c29@redhat.com> <5927e04b-42ec-52c1-88a3-456cc4409334@talpey.com> <HE1PR0501MB28124286F8D902C49596EF85B18C0@HE1PR0501MB2812.eurprd05.prod.outlook.com> <20161130163949.GC24639@obsidianresearch.com> <HE1PR0501MB28128CDB112558C5980CB638B18C0@HE1PR0501MB2812.eurprd05.prod.outlook.com> <20161130170830.GA17512@obsidianresearch.com> <1828884A29C6694DAF28B7E6B8A82373AB0BA190@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB0BA190-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "'Hefty, Sean'" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, 'Liran Liss' <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: 'Tom Talpey' <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Steve Wise' <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, "'Marciniszyn, Mike'" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "'Dalessandro, Dennis'" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Lijun Ou' <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "'Wei Hu(Xavier)'" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "'Latif, Faisal'" <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Selvin Xavier' <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, 'Devesh Sharma' <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, 'Mitesh Ahuja' <mitesh.ahuja-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, 'Christian Benvenuti' <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, 'Dave Goodell' <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Or Gerlitz' <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 
> > > - this doesn't change anything.  Also, AHs are already
> > > port-specific. So, I don't see any issue in this regard.
> >
> > The current scheme infers the protocol of the AH from the current
> > configuration of the port, which is a crazy API when the port's
> > protocol can change on the fly.
> 
> Maybe the solution is to make the protocol selection explicit throughout the
APIs
> and associate it with a QP, rather than attempting to list all transport
protocols that
> a port can support.

Do you mean requiring the application to pick the protocol?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
