From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] IB/mlx5:: pr_err() and mlx5_ib_dbg() strings should end
 with newlines
Date: Tue, 26 Sep 2017 12:11:45 -0700
Message-ID: <1506453105.29089.14.camel@perches.com>
References: <7a5a195cd37db476a2ca007eddc0f28f3ade265b.1506407876.git.arvind.yadav.cs@gmail.com>
         <20170926083843.GB6816@mtr-leonro.local>
         <1506438337.29089.8.camel@perches.com>
         <20170926155006.GD6816@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170926155006.GD6816@mtr-leonro.local>
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>
Cc: Arvind Yadav <arvind.yadav.cs@gmail.com>, matanb@mellanox.com, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-09-26 at 18:50 +0300, Leon Romanovsky wrote:
> So how can I reproduce the different output before and after this change?

Try lib/test_module.c with and without the newline
on "Hello, World" on a quiescent system.
