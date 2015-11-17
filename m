From: Or Gerlitz <ogerlitz@mellanox.com>
Subject: Re: [PATCH for-next 09/10] IB/iser: Increment the rkey when
 registering and not when invalidating
Date: Tue, 17 Nov 2015 10:13:46 +0200
Message-ID: <564AE1BA.2040204@mellanox.com>
References: <1447691861-3796-1-git-send-email-sagig@mellanox.com>
 <1447691861-3796-10-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1447691861-3796-10-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Steve Wise <swise@opengridcomputing.com>
List-Id: linux-rdma@vger.kernel.org

On 11/16/2015 6:37 PM, Sagi Grimberg wrote:
> With remote invalidate we won't local invalidate
> but we still want to increment the rkey.

To ease with review, as this is low level pre-patch, please push it to 
downstream area
of the series, e.g before the patch that introduces include/scsi/iser.h 
-- also use comma
to make the sentence more readable, maybe something like: "With remote 
invalidate we won't
do local invalidate, but we still want to increment the rkey."

Or.
