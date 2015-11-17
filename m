From: Or Gerlitz <ogerlitz@mellanox.com>
Subject: Re: [PATCH for-next 10/10] IB/iser: Support the remote invalidation
 exception
Date: Tue, 17 Nov 2015 12:04:03 +0200
Message-ID: <564AFB93.9010602@mellanox.com>
References: <1447691861-3796-1-git-send-email-sagig@mellanox.com>
 <1447691861-3796-11-git-send-email-sagig@mellanox.com>
 <564ADFCC.4030109@mellanox.com> <564AF929.60209@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <564AF929.60209@dev.mellanox.co.il>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>, Sagi Grimberg <sagig@mellanox.com>, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Steve Wise <swise@opengridcomputing.com>, Jenny Derzhavetz <jennyf@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On 11/17/2015 11:53 AM, Sagi Grimberg wrote:
> [...] iSER lacks support for bidirectional commands for as long as I'm 
> involved with it 


Why? we don't support and when did we broke it after the initial 2.6.18 
upstreaming of the driver

Also, do we refuse to queuecommand a bidi? where?
