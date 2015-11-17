From: Or Gerlitz <ogerlitz@mellanox.com>
Subject: Re: [PATCH for-next 04/10] IB/iser: set intuitive values for mr_valid
Date: Tue, 17 Nov 2015 09:43:49 +0200
Message-ID: <564ADAB5.3080208@mellanox.com>
References: <1447691861-3796-1-git-send-email-sagig@mellanox.com>
 <1447691861-3796-5-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1447691861-3796-5-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Steve Wise <swise@opengridcomputing.com>, Jenny Derzhavetz <jennyf@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On 11/16/2015 6:37 PM, Sagi Grimberg wrote:
> This parameter is described as "is mr valid indicator".
> In other words, it indicates whether memory registration
> is valid or not. So intuitive values would be:
> mr_valid=True, when memory registration is valid and
> mr_valid=False otherwise.

and what was there before? the other way around?

on what cases the indicator is false (with the new semantics)?

Also, we have a convention of starting commit titles with capital 
letters, please follow on that "Set iser [...]"
