From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH v2] {net, IB}/mlx5: Use 'kvfree()' for memory allocated by
 'kvzalloc()'
Date: Sun, 13 May 2018 09:21:26 -0700
Message-ID: <91c6f7a0-e099-5b93-1b3a-f16f650adc2e@gmail.com>
References: <20180513070041.24246-1-christophe.jaillet@wanadoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180513070041.24246-1-christophe.jaillet@wanadoo.fr>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>, saeedm@mellanox.com, matanb@mellanox.com, leon@kernel.org, dledford@redhat.com, jgg@ziepe.ca, davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org



On 05/13/2018 12:00 AM, Christophe JAILLET wrote:
> When 'kvzalloc()' is used to allocate memory, 'kvfree()' must be used to
> free it.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> v1 -> v2: More places to update have been added to the patch


Please add relevant Fixes: tag(s)
