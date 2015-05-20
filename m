From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-next 08/10] IB/mlx4: Add support for timestamp in
 cq creation
Date: Wed, 20 May 2015 11:56:37 +0300
Message-ID: <555C4C45.7010300@dev.mellanox.co.il>
References: <1431869786-6308-1-git-send-email-ogerlitz@mellanox.com> <1431869786-6308-9-git-send-email-ogerlitz@mellanox.com> <20150519185527.GL18675@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150519185527.GL18675-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 5/19/2015 9:55 PM, Jason Gunthorpe wrote:
> On Sun, May 17, 2015 at 04:36:24PM +0300, Or Gerlitz wrote:
>> @@ -110,6 +110,7 @@ struct mlx4_ib_cq {
>>   	struct mutex		resize_mutex;
>>   	struct ib_umem	       *umem;
>>   	struct ib_umem	       *resize_umem;
>> +	int			create_flags;
>
> flags is u32

Maybe even u64 so we wont run out of bits like we did in
device_cap_flags.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
