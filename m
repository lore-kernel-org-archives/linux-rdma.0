From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Need to set if_index in ib_init_ah_from_wc() ?
Date: Thu, 9 Feb 2017 11:48:58 -0700
Message-ID: <20170209184858.GB809@obsidianresearch.com>
References: <20170130195412.GE24466@obsidianresearch.com>
 <VI1PR0502MB30081EBFBEE5994B77D58BB9D14B0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170130211420.GB27111@obsidianresearch.com>
 <VI1PR0502MB30081EC9B35269636B4C2FBCD14B0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170130221437.GA28117@obsidianresearch.com>
 <VI1PR0502MB3008B16A0F103D729209EA16D14A0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170131005340.GA30809@obsidianresearch.com>
 <CAAKD3BDbkFHbCi+gHyCXCGV2xi5E9FA+KgwKz+6dBJEtsV0ZkQ@mail.gmail.com>
 <20170208174040.GC30720@obsidianresearch.com>
 <CAAKD3BD88Kp2h3+vP4iMy5T4rR6=Y39ZnNXRLM1P-6G6iB=BNQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAAKD3BD88Kp2h3+vP4iMy5T4rR6=Y39ZnNXRLM1P-6G6iB=BNQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 09, 2017 at 10:40:38AM +0200, Matan Barak wrote:

> Well, some applications (maybe a lot of them), creates an AH from
> the first received packet (of each node) and then just assumes the
> rest of the packets comes from the same logical netdev.  Since there
> is no binding to a netdev, other packets could differ vastly from
> this one. That's what I meant by "symmetrical".

Such applications should create a UD QP per netdev they want to
operate on.

There is no good reason to have a single 'all device' UD QP in user
space.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
