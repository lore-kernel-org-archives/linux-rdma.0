From: Steve Wise <swise@opengridcomputing.com>
Subject: Re: [PATCH v1 iproute2-next 1/4] rdma: add helper rd_sendrecv_msg()
Date: Wed, 6 Mar 2019 15:50:13 -0600
Message-ID: <b487f61e-d9a7-0151-51f5-25f79597a2fa@opengridcomputing.com>
References: <cover.1550773362.git.swise@opengridcomputing.com>
 <aa883bc5ffd63047cf57e2f9925002e7573fd7ac.1550773362.git.swise@opengridcomputing.com>
 <20190223092615.GM23561@mtr-leonro.mtl.com>
 <11ec7e04-1bff-e3b2-1b89-db134cd537ba@opengridcomputing.com>
 <021201d4ceda$56d9e560$048db020$@opengridcomputing.com>
 <20190303135052.GY15253@mtr-leonro.mtl.com>
 <007901d4d294$62d5d280$28817780$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <007901d4d294$62d5d280$28817780$@opengridcomputing.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: 'Leon Romanovsky' <leon@kernel.org>
Cc: dsahern@gmail.com, stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


On 3/4/2019 8:13 AM, Steve Wise wrote:
> Hey Leon, adding this to rd_recv_msg():
>
> @@ -693,10 +693,28 @@ int rd_recv_msg(struct rd *rd, mnl_cb_t callback, void
> *data, unsigned int seq)
>                 ret = mnl_cb_run(buf, ret, seq, portid, callback, data);
>         } while (ret > 0);
>
> +       if (ret < 0)
> +               perror(NULL);
> +
>         mnl_socket_close(rd->nl);
>         return ret;
>  }
>
> Results in unexpected errors being logged when doing a query such as:
>
> [root@stevo1 iproute2]# ./rdma/rdma res show qp lqpn 176
> error: Invalid argument
> link mlx5_0/1 lqpn 176 type UD state RTS sq-psn 0 comm [ib_core]
> error: Invalid argument
> error: No such file or directory
> error: Invalid argument
> error: No such file or directory
>
> It appears the "invalid argument" errors are due to rdmatool sending a
> RDMA_NLDEV_CMD_RES_QP_GET command using the doit kernel method to allow
> querying for just a QP with lqpn = 176.  However, rdmatool isn't passing a
> port index in the messages that generate the "invalid argument" error from
> the kernel.  IE you must provide a device index and port index when issuing
> a doit command vs a dumpit command.  I think. 
>
> This error was not found because rd_recv_msg() never displayed any errors
> previously.  Further, the RES_FUNC() massive macro has code that will retry
> a failed doit call with a dumpit call.  I think _##name() should distinguish
> between failures reported by the kernel doit function vs failures because no
> doit function exists.  Not sure how to support that.
>
>
>         static inline int _##name(struct rd *rd)
> \
>         {
> \
>                 uint32_t idx;
> \
>                 int ret;
> \
>                 if (id) {
> \
>                         ret = rd_doit_index(rd, &idx);
> \
>                         if (ret) {
> \
>                                 ret = _res_send_idx_msg(rd, command,
> \
>                                                         name##_idx_parse_cb,
> \
>                                                         idx, id);
> \
>                                 if (!ret)
> \
>                                         return ret;
> \
>                                 /* Fallback for old systems without .doit
> callbacks */ \
>                         }
> \
>                 }
> \
>                 return _res_send_msg(rd, command, name##_parse_cb);
> \
>         }
> \
>
>
>
> The "no such file or dir" errors are being returned because, in my setup,
> there are 2 other links that do not have lqpn 176.   So there are 2 issues
> uncovered by adding generic printing of errors in rd_recv_msg()
>
> 1) the doit code in rdmatool is generating requests for a doit method in the
> kernel w/o providing a port index.
> 2) some paths in rdmatool should not print "benign" errors like filtering on
> a GET command causing a "does not exist" error returned by the kernel doit
> func.
>
> #1 is a bug, IMO.  Can you propose a fix?
> #2 could be solved by adding an error callback func passed to rd_recv_msg().
> Then the RES_FUNC() functions could parse errors like "no such file or dir"
> when doing a filtered query and silently drop them.  And functions like
> dev_set_name() would display all errors returned because there are no
> expected errors other than "success".
>
> Steve.
>

Hey Leon, you've been quiet. :)   Thoughts?

Thanks,

Steve.
