From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH v2 3/6] RDMA/core: expose affinity mappings per completion
 vector
Date: Wed, 3 May 2017 11:02:14 +0300
Message-ID: <c477c396-f9ae-6c60-18a2-c70d2998d7ef@grimberg.me>
References: <1491474998-16423-1-git-send-email-sagi@grimberg.me>
 <1491474998-16423-4-git-send-email-sagi@grimberg.me>
 <1493419685.3041.174.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1493419685.3041.174.camel@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Saeed Mahameed <saeedm@mellanox.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, linux-rdma@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Or Gerlitz <ogerlitz@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>
List-Id: linux-rdma@vger.kernel.org


>> This will allow ULPs to intelligently locate threads based
>> on completion vector cpu affinity mappings. In case the
>> driver does not expose a get_vector_affinity callout, return
>> NULL so the caller can maintain a fallback logic.
>>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>> Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
>>
>
> Acked-by: Doug Ledford <dledford@redhat.com>

Thanks Doug,

Saeed, I did not receive any feedback from you on this patchset.
I got a review tag from Leon, which is sufficient to move forward
with this for 4.13 I guess.
