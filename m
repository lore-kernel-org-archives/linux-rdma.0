From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] IB/iser: extended CDB support
Date: Tue, 29 Nov 2016 15:16:33 +0200
Message-ID: <d1dce2ed-d10b-a435-5d5c-d7baa4c571ba@mellanox.com>
References: <1479891139-15604-1-git-send-email-vladimirn@mellanox.com>
 <04534a11-df1c-eff7-14c5-65c1050f3393@mellanox.com>
 <20161129080232.GA11368@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161129080232.GA11368-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Vladimir Neyelov <vladimirn-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 11/29/2016 10:02 AM, Christoph Hellwig wrote:
> On Tue, Nov 29, 2016 at 09:43:12AM +0200, Max Gurtovoy wrote:
>> Sagi/Christopth,
>>
>> any thoughts on this onw ?
>>
>> On 11/23/2016 10:52 AM, Vladimir Neyelov wrote:
>>> Support of vendor specific CDBs in iser.
>
> This command surely is wrong.
>
> Except for that: what's the use case?  The only use case for gigantic
> CDBs in iSCSI was the T10 OSD code, which hopefully is on it's way out.
>
> Or do you just need 32 byte CDBs, in whіch case things could probably
> be done much simpler.
>

we needed to support 22 byte CDB (in the case we encountered the 
problem) but we wanted to be aligned with the tcp implementation that 
support SCSI_MAX_VARLEN_CDB_SIZE.
notice that on the wire we send only the actual CDB size and not all the 
SCSI_MAX_VARLEN_CDB_SIZE.
I guess you're concern about allocating extra 244B for each task, right ?
AFAIK we didn't see difference in perf with this patch but it worth to 
re-check it and share numbers with the community.

regarding the simplicity, I guess the support for 32B CDB will be pretty 
much similar to this commit, unless you see some simpler solution.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
