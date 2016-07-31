From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH 2/2] nvme-rdma: Add handling for connecting to IPv6
 targets
Date: Sun, 31 Jul 2016 13:58:23 +0300
Message-ID: <33dfc646-1804-363e-4d83-1ba618303dbb@grimberg.me>
References: <1469950060-18098-1-git-send-email-roland@kernel.org>
 <1469950060-18098-2-git-send-email-roland@kernel.org>
 <4acdd466-b8f6-8208-7287-e97dfd45bbf1@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4acdd466-b8f6-8208-7287-e97dfd45bbf1-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> On 31/07/16 10:27, Roland Dreier wrote:
>> From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
>>
>> If a target address does not parse as IPv4, try parsing it as IPv6
>> (including handling '%<scope-id>' suffixes for link-local addresses).
>>
>> Signed-off-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
>
>
> Nice! thanks Roland,
>
> testing it now...

How did you test it btw?

Currently the target driver doesn't support ipv6 addresses.

These complementary patches [1,2] makes the it work e2e! So,

Reviewed-by: Sagi Grimberg <sagi-egDjqUIXVlxBDLzU/O5InQ@public.gmane.org>
and,
Tested-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>


[1]:
--
commit 068d8e511d9a6927721bddfd545ad4976196297d
Author: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Date:   Sun Jul 31 13:45:44 2016 +0300

     nvmet-rdma: Add ipv6 support

     Allow the nvme-rdma target accept connections using
     ipv6 address resolution.

     Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>

diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index 4e83d92d6bdd..347cc6d37dad 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -1336,29 +1336,65 @@ restart:
         mutex_unlock(&nvmet_rdma_queue_mutex);
  }

-static int nvmet_rdma_add_port(struct nvmet_port *port)
+static int nvmet_rdma_set_addr_port(int family, char *ipaddr,
+               char *ipport, struct sockaddr_storage *addr)
  {
-       struct rdma_cm_id *cm_id;
-       struct sockaddr_in addr_in;
-       u16 port_in;
-       int ret;
+       size_t buflen = strlen(ipaddr);
+       struct sockaddr_in *addr4;
+       struct sockaddr_in6 *addr6;
+       u16 port;
+
+       if (kstrtou16(ipport, 0, &port))
+               return -EINVAL;

-       switch (port->disc_addr.adrfam) {
+       switch (family) {
         case NVMF_ADDR_FAMILY_IP4:
+               if (buflen > INET_ADDRSTRLEN)
+                       return -EINVAL;
+
+               addr4 = (struct sockaddr_in *)addr;
+
+               if (in4_pton(ipaddr, buflen, (u8 *)&addr4->sin_addr.s_addr,
+                            '\n', NULL) == 0)
+                       return -EINVAL;
+
+               addr4->sin_family = AF_INET;
+               addr4->sin_port = htons(port);
+               break;
+       case NVMF_ADDR_FAMILY_IP6:
+               if (buflen > INET6_ADDRSTRLEN)
+                       return -EINVAL;
+
+               addr6 = (struct sockaddr_in6 *) addr;
+
+               if (in6_pton(ipaddr, buflen, (u8 
*)&addr6->sin6_addr.s6_addr,
+                            '\n', NULL) == 0)
+                       return -EINVAL;
+
+               addr6->sin6_family = AF_INET6;
+               addr6->sin6_port = htons(port);
                 break;
         default:
-               pr_err("address family %d not supported\n",
-                               port->disc_addr.adrfam);
+               pr_err("address family %d not supported\n", family);
                 return -EINVAL;
         }

-       ret = kstrtou16(port->disc_addr.trsvcid, 0, &port_in);
-       if (ret)
-               return ret;
+       return 0;
+}

-       addr_in.sin_family = AF_INET;
-       addr_in.sin_addr.s_addr = in_aton(port->disc_addr.traddr);
-       addr_in.sin_port = htons(port_in);
+static int nvmet_rdma_add_port(struct nvmet_port *port)
+{
+       struct rdma_cm_id *cm_id;
+       struct sockaddr_storage addr = { };
+       int ret;
+
+       ret = nvmet_rdma_set_addr_port(port->disc_addr.adrfam,
+               port->disc_addr.traddr, port->disc_addr.trsvcid, &addr);
+       if (ret) {
+               pr_err("failed setting addr %s:%s\n",
+               port->disc_addr.traddr, port->disc_addr.trsvcid);
+               return ret;
+       }

         cm_id = rdma_create_id(&init_net, nvmet_rdma_cm_handler, port,
                         RDMA_PS_TCP, IB_QPT_RC);
@@ -1367,20 +1403,33 @@ static int nvmet_rdma_add_port(struct nvmet_port 
*port)
                 return PTR_ERR(cm_id);
         }

-       ret = rdma_bind_addr(cm_id, (struct sockaddr *)&addr_in);
+       /*
+        * Allow both IPv4 and IPv6 sockets to bind a single port
+        * at the same time.
+        */
+       ret = rdma_set_afonly(cm_id, 1);
+       if (ret) {
+               pr_err("rdma_set_afonly failed (%d)\n", ret);
+               goto out_destroy_id;
+       }
+
+       ret = rdma_bind_addr(cm_id, (struct sockaddr *)&addr);
         if (ret) {
-               pr_err("binding CM ID to %pISpc failed (%d)\n", 
&addr_in, ret);
+               pr_err("binding CM ID to %pISpcs failed (%d)\n",
+                       (struct sockaddr *)&addr, ret);
                 goto out_destroy_id;
         }

         ret = rdma_listen(cm_id, 128);
         if (ret) {
-               pr_err("listening to %pISpc failed (%d)\n", &addr_in, ret);
+               pr_err("listening to %pISpcs failed (%d)\n",
+                       (struct sockaddr *)&addr, ret);
                 goto out_destroy_id;
         }

-       pr_info("enabling port %d (%pISpc)\n",
-               le16_to_cpu(port->disc_addr.portid), &addr_in);
+       pr_info("enabling port %d (%pISpcs)\n",
+               le16_to_cpu(port->disc_addr.portid),
+               (struct sockaddr *)&addr);
         port->priv = cm_id;
         return 0;
--

[2]:
--
commit 6d962c76580680e9cd0f5a56f47bcd30b5a39dd7
Author: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Date:   Sun Jul 31 13:56:58 2016 +0300

     fabrics: Allow ipv6 address resolution

     Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>

diff --git a/fabrics.c b/fabrics.c
index 4bf557b5e672..221e34e5e39b 100644
--- a/fabrics.c
+++ b/fabrics.c
@@ -390,7 +390,8 @@ static int connect_ctrl(struct 
nvmf_disc_rsp_page_entry *e)
                 /* we can safely ignore the rest of the entries */
                 break;
         case NVMF_TRTYPE_RDMA:
-               if (e->adrfam != NVMF_ADDR_FAMILY_IP4) {
+               if (e->adrfam != NVMF_ADDR_FAMILY_IP4 &&
+                   e->adrfam != NVMF_ADDR_FAMILY_IP6) {
                         fprintf(stderr, "skipping unsupported adrfam\n");
                         return -EINVAL;
                 }
--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
