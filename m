From: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Subject: Re: [PATCH net-next] rds: store socket timestamps as ktime_t
Date: Wed, 29 Aug 2018 10:00:01 -0700
Message-ID: <9758170c-d6f1-5d0a-b05c-12724ebaa0c6@oracle.com>
References: <20180829154732.844217-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180829154732.844217-1-arnd@arndb.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, "David S. Miller" <davem@davemloft.net>
Cc: Sowmini Varadhan <sowmini.varadhan@oracle.com>, Willem de Bruijn <willemb@google.com>, Ka-Cheong Poon <ka-cheong.poon@oracle.com>, Salvatore Mesoraca <s.mesoraca16@gmail.com>, Avinash Repaka <avinash.repaka@oracle.com>, Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 8/29/2018 8:47 AM, Arnd Bergmann wrote:
> rds is the last in-kernel user of the old do_gettimeofday()
> function. Convert it over to ktime_get_real() to make it
> work more like the generic socket timestamps, and to let
> us kill off do_gettimeofday().
> 
> A follow-up patch will have to change the user space interface
> to deal better with 32-bit tasks, which may use an incompatible
> layout for 'struct timespec'.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
Thanks Arnd !!

FWIW,
Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
