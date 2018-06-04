From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] net: ethernet: mlx4: Remove unnecessary parentheses
Date: Mon, 04 Jun 2018 10:15:19 -0400 (EDT)
Message-ID: <20180604.101519.1313033740038335042.davem@davemloft.net>
References: <20180601020049.3704-1-rvarsha016@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180601020049.3704-1-rvarsha016@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: rvarsha016@gmail.com
Cc: tariqt@mellanox.com, der.herr@hofr.at, lukas.bulwahn@gmail.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Varsha Rao <rvarsha016@gmail.com>
Date: Fri,  1 Jun 2018 07:30:49 +0530

> This patch fixes the clang warning of extraneous parentheses, with the
> following coccinelle script.
 ...
> Suggested-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> Signed-off-by: Varsha Rao <rvarsha016@gmail.com>

Applied to net-next, thanks.
