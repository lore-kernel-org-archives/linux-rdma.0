From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: iSER fails to release rdma resources (WRs) if iw_cxgb4 is
 unloaded while IO is in progress
Date: Thu, 23 Feb 2017 12:05:01 +0200
Message-ID: <acc82d4f-e7d2-42d6-2b46-c1347dc65160@mellanox.com>
References: <CY1PR12MB077405C1FA5279D200AD3089BC4D0@CY1PR12MB0774.namprd12.prod.outlook.com>
 <49223bb6-e2a1-eee7-cf4e-701957e6727f@mellanox.com>
 <CY1PR12MB07749731AC32F7BE065CC51DBC4C0@CY1PR12MB0774.namprd12.prod.outlook.com>
 <c0a53feb-8c15-54af-c443-fbc4f3d5ec0e@mellanox.com>
 <AM4PR0501MB27867EED1435EE19BDE2CEC7CB5E0@AM4PR0501MB2786.eurprd05.prod.outlook.com>
 <c51ef366-39a9-b8bc-f8ec-353c953397d1@grimberg.me>
 <AM4PR0501MB2786F74877EC0391E3865EA9CB530@AM4PR0501MB2786.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AM4PR0501MB2786F74877EC0391E3865EA9CB530-dp/nxUn679hhbxXPg6FtWcDSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vladimir Neyelov <vladimirn-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Raju Rangoju <rajur-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: SWise OGC <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 2/23/2017 10:27 AM, Vladimir Neyelov wrote:
> Hi,
> I didn't see your patch. But if it's similar patch it's very good that two people think about same solution.
> Vladimir.
>
> -----Original Message-----
> From: Sagi Grimberg [mailto:sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org]
> Sent: Wednesday, February 22, 2017 9:59 PM
> To: Vladimir Neyelov <vladimirn-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Raju Rangoju <rajur-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: SWise OGC <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>; Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
> Subject: Re: iSER fails to release rdma resources (WRs) if iw_cxgb4 is unloaded while IO is in progress
>
>> Hi Raju,
>> Try this patch that solve this problem, it checked with our tests.
>
> I might be missing something, but how is this patch any different then what I sent (other than duplicating some code)?
>

Sagi,
can you send your patch again ?
I missed it too.

thanks,
Max.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
