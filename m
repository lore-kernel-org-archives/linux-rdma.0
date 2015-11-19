From: Or Gerlitz <ogerlitz@mellanox.com>
Subject: Re: [PATCH for-next 08/10] iser-target: Support the remote
 invalidation exception
Date: Thu, 19 Nov 2015 09:25:42 +0200
Message-ID: <564D7976.3080202@mellanox.com>
References: <1447691861-3796-1-git-send-email-sagig@mellanox.com>
 <1447691861-3796-9-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1447691861-3796-9-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Steve Wise <swise@opengridcomputing.com>, Jenny Derzhavetz <jennyf@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On 11/16/2015 6:37 PM, Sagi Grimberg wrote:
>   	struct isert_conn	*conn;
> @@ -209,6 +210,7 @@ struct isert_conn {
>   	struct work_struct	release_work;
>   	struct ib_recv_wr       beacon;
>   	bool                    logout_posted;
> +	bool                    snd_w_inv;
>   };

We've gone into this aspect few times in the past... my preference
is to use bit flags so the code would look like

conn->flags |= ISER_CONN_SEND_W_INV

or

if (conn->flags & ISER_CONN_LOGOUT_POSTED)

And you didn't want to go that way... but you did used
bit-fields in other areas of the driver, right?

Lets use some sort of BF-ing (bit fields or bit flags) all over the place
and not introduce new booleans everywhere we go.

Doing this over and over makes our fast path structures to grow and
maybe start crossing cache-lines (did you check that?)

Or.
