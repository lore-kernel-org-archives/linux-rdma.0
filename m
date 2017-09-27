From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] IB/ocrdma: pr_err() strings should end with newlines
Date: Wed, 27 Sep 2017 10:20:55 -0400
Message-ID: <1506522055.82712.27.camel@redhat.com>
References: <28298577a7f6111b2d40780dddd3c87a32168ab7.1506408446.git.arvind.yadav.cs@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <28298577a7f6111b2d40780dddd3c87a32168ab7.1506408446.git.arvind.yadav.cs@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Arvind Yadav <arvind.yadav.cs@gmail.com>, selvin.xavier@broadcom.com, sean.hefty@intel.com, hal.rosenstock@gmail.com
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-09-26 at 12:21 +0530, Arvind Yadav wrote:
> pr_err() messages should end with a new-line to avoid other messages
> being concatenated.
> 
> Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>

Thanks, applied.

-- 
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
