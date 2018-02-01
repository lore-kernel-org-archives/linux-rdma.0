From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH RFC 2/2] RDMA/nldev: provide detailed CM_ID information
Date: Thu, 1 Feb 2018 12:14:40 -0600
Message-ID: <013301d39b88$86df1220$949d3660$@opengridcomputing.com>
References: <cover.1517418595.git.swise@opengridcomputing.com> <531889e6a24f7919dec71734c91298d266aa9721.1517418595.git.swise@opengridcomputing.com> <VI1PR0502MB3008805F1A6056F50A12DEDBD1FB0@VI1PR0502MB3008.eurprd05.prod.outlook.com> <01ea01d39ad5$ec30f7a0$c492e6e0$@opengridcomputing.com> <VI1PR0502MB30088B50BEA14B4C05EA2BC7D1FB0@VI1PR0502MB3008.eurprd05.prod.outlook.com> <20180201080109.GG2055@mtr-leonro.local> <20180201175028.GS17053@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180201175028.GS17053-uk2M96/98Pc@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgg-uk2M96/98Pc@public.gmane.org>, 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: 'Parav Pandit' <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> 
> On Thu, Feb 01, 2018 at 10:01:09AM +0200, Leon Romanovsky wrote:
> 
> > Regarding the name, I personally think that cm_id is better because it
> > is general and applicable both to ib_cm and iw_cm. The separation
> > between them can be done with introduction of new netlink attribute,
e.g.
> > cm_id_type.
> 
> In netlink the attributes should be self-describing, or intrinsically
> related to something mandatory and fundamental about their container
> (eg AF_ family in rtnl)
> 
> What information do we actually need from the cm_id in various
> protocol families?
> 

Looking at iw_cm_id and iwcm_id_private: tos, mapped, state, flags,
refcount.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
