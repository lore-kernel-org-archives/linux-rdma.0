From: Sowmini Varadhan <sowmini.varadhan@oracle.com>
Subject: Re: [PATCH][rds-next] rds: make functions rds_info_from_znotifier
 and rds_message_zcopy_from_user static
Date: Sun, 11 Mar 2018 13:22:07 -0400
Message-ID: <20180311172207.GB7812@oracle.com>
References: <20180311170340.27696-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180311170340.27696-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Santosh Shilimkar <santosh.shilimkar@oracle.com>, "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On (03/11/18 18:03), Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Functions rds_info_from_znotifier and rds_message_zcopy_from_user are
> local to the source and do not need to be in global scope, so make them
> static.

the rds_message_zcopy_from_user warning was already flagged by  kbuild-robot
last week.  See
   https://www.spinics.net/lists/netdev/msg488041.html


 
