From: "santosh.shilimkar@oracle.com" <santosh.shilimkar@oracle.com>
Subject: Re: [PATCH][rds-next] rds: make functions rds_info_from_znotifier and
 rds_message_zcopy_from_user static
Date: Mon, 12 Mar 2018 00:04:29 -0700
Message-ID: <046b2275-ba1f-3827-3664-b7c9553ffec3@oracle.com>
References: <20180311170340.27696-1-colin.king@canonical.com>
 <b693b404-3c66-5c45-4610-e119956c8dff@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <b693b404-3c66-5c45-4610-e119956c8dff@oracle.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>, "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 3/11/18 11:54 PM, santosh.shilimkar@oracle.com wrote:
> On 3/11/18 10:03 AM, Colin King wrote:
>> From: Colin Ian King <colin.king@canonical.com>
>>
>> Functions rds_info_from_znotifier and rds_message_zcopy_from_user are
>> local to the source and do not need to be in global scope, so make them
>> static.
>>
>> Cleans up sparse warnins:
>> net/rds/message.c:70:27: warning: symbol 'rds_info_from_znotifier' was
>> not declared. Should it be static?
>> net/rds/message.c:358:5: warning: symbol 'rds_message_zcopy_from_user'
>> was not declared. Should it be static?
>>
>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>> ---
>>   net/rds/message.c | 6 ++++--
>>   1 file changed, 4 insertions(+), 2 deletions(-)
>>
> Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>

This was fixed by kbuild robot and the fix is already in net-next.

Regards,
Santosh
