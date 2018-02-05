From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: Regression: Connect-X5 doesn't connect with NVME-of
Date: Mon, 5 Feb 2018 17:59:56 +0200
Message-ID: <bcbc8826-994f-3b90-3bef-cdf659164b7b@mellanox.com>
References: <66a5332c-01ee-7a39-8224-189fa52a7298@deltatee.com>
 <e6cdfbe7-762c-c70c-be5f-397bdb08ee80@mellanox.com>
 <0d629a68-a1fa-7297-e371-5abbc2dd5fe7@grimberg.me>
 <dbda15f0-f678-9fab-dffe-5e8d2ae24ae1@mellanox.com>
 <7941ee6c-bf13-093c-e5c2-9ed93889405d@grimberg.me>
 <1517845472.11655.3.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1517845472.11655.3.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: he
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Stephen Bates <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>, linux-nvme <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 2/5/2018 5:44 PM, Laurence Oberman wrote:
> On Mon, 2018-02-05 at 16:18 +0200, Sagi Grimberg wrote:
>>> Hi Sagi/Logan,
>>>
>>> I've repro it with v4.14.1 (not happens on each connect).
>>> Sagi's proposal below fix the issue of the "Failed to write to
>>> /dev/nvme-fabrics: Invalid cross-device link".
>>>
>>> Sagi can you push (with my Tested-by: Max Gurtovoy <maxg@mellanox.c
>>> om>
>>> and Reviewed-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>) it or I will ?
>>
>> Thanks, I'll send it.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma"
>> in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> This missed me because all my NVME is still using CX3 (mlx4)
> I will move the NVME devices into the setup with mlx5 so next time I
> will catch this sort of issue with the testing.
> Currently the mlx5 is only testing ISER and SRP.

Thanks Laurence,
This is well appreciated :)

> 
> Thanks
> Laurence
> 

Cheers,
Max
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
