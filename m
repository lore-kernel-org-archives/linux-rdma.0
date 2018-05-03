From: Boris Pismenny <borisp@mellanox.com>
Subject: Re: [bug report] net/mlx5e: TLS, Add Innova TLS TX offload data path
Date: Thu, 3 May 2018 19:04:14 +0300
Message-ID: <1c4a001c-b3a8-bf35-52c0-78526804ffcc@mellanox.com>
References: <20180503112300.GA6309@mwanda>
 <20180503120757.GA1641@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180503120757.GA1641@mtr-leonro.local>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>, Dan Carpenter <dan.carpenter@oracle.com>, Saeed Mahameed <saeedm@mellanox.com>
Cc: linux-rdma@vger.kernel.org, netdev@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Hi Dan,

Thanks for taking a look at our code.

On 05/03/18 15:07, Leon Romanovsky wrote:
> + Saeed, Boris and netdev
>
> On Thu, May 03, 2018 at 02:23:00PM +0300, Dan Carpenter wrote:
>> Hello Ilya Lesokhin,
>>
>> The patch bf23974104fa: "net/mlx5e: TLS, Add Innova TLS TX offload
>> data path" from Apr 30, 2018, leads to the following static checker
>> warning:
>>
>> 	drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c:63 mlx5e_tls_add_metadata()
>> 	warn: struct type mismatch 'ethhdr vs mlx5e_tls_metadata'
>>
>> drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
>>      55  static int mlx5e_tls_add_metadata(struct sk_buff *skb, __be32 swid)
>>      56  {
>>      57          struct mlx5e_tls_metadata *pet;
>>      58          struct ethhdr *eth;
>>                  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>      59
>>      60          if (skb_cow_head(skb, sizeof(struct mlx5e_tls_metadata)))
>>                                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>      61                  return -ENOMEM;
>>      62
>>      63          eth = (struct ethhdr *)skb_push(skb, sizeof(struct mlx5e_tls_metadata));
>>                                                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>> This feels like it should be sizeof(*eth) + sizeof(*pet)?
No, we add only "sizeof(struct mlx5e_tls_metadata)" bytes to the skb 
headroom for the mlx5_tls_metadata. The Ethernet header is already there.
>>
>>      64          skb->mac_header -= sizeof(struct mlx5e_tls_metadata);
>>      65          pet = (struct mlx5e_tls_metadata *)(eth + 1);
>>      66
>>      67          memmove(skb->data, skb->data + sizeof(struct mlx5e_tls_metadata),
>>      68                  2 * ETH_ALEN);
>>      69
>>      70          eth->h_proto = cpu_to_be16(MLX5E_METADATA_ETHER_TYPE);
>>      71          pet->syndrome_swid = htonl(SYNDROME_OFFLOAD_REQUIRED << 24) | swid;
>>      72
>>      73          return 0;
>>      74  }
>>
>> regards,
>> dan carpenter
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
Best,
Boris.
