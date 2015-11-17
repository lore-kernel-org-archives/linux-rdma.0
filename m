From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH for-next 06/10] iser-target: Remove unused file
 iser_proto.h
Date: Tue, 17 Nov 2015 11:45:28 +0200
Message-ID: <564AF738.3060103@dev.mellanox.co.il>
References: <1447691861-3796-1-git-send-email-sagig@mellanox.com>
 <1447691861-3796-7-git-send-email-sagig@mellanox.com>
 <564ADDCE.4010501@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <564ADDCE.4010501@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: Or Gerlitz <ogerlitz@mellanox.com>, Sagi Grimberg <sagig@mellanox.com>, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Steve Wise <swise@opengridcomputing.com>
List-Id: linux-rdma@vger.kernel.org



On 17/11/2015 09:57, Or Gerlitz wrote:
> On 11/16/2015 6:37 PM, Sagi Grimberg wrote:
>> -/* From iscsi_iser.h */
>> -
>> -struct iser_hdr {
>> -    u8    flags;
>> -    u8    rsvd[3];
>> -    __be32    write_stag; /* write rkey */
>> -    __be64    write_va;
>> -    __be32    read_stag;  /* read rkey */
>> -    __be64    read_va;
>> -} __packed;
>> -
>> -/*Constant PDU lengths calculations */
>> -#define ISER_HEADERS_LEN  (sizeof(struct iser_hdr) + sizeof(struct
>> iscsi_hdr))
>
> move this part of the cleanup to the preceding patch, so it can be
> reviewed and bisected into
> regardless of this or any downstream patch of the series.

You're right... will fix..
