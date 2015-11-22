From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] IB/mlx5: fix null dereference
Date: Sun, 22 Nov 2015 09:41:37 -0800
Message-ID: <20151122174137.GA31739@infradead.org>
References: <1448196517-13341-1-git-send-email-saurabh.truth@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1448196517-13341-1-git-send-email-saurabh.truth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Saurabh Sengar <saurabh.truth@gmail.com>
Cc: eli@mellanox.com, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Nov 22, 2015 at 06:18:37PM +0530, Saurabh Sengar wrote:
> removing null dereference

How so?  These are just sparse annotations, so I can't see how we'll
actually derference them.  That beeing said they certainly are
incorrect..
