From: "Ruhl, Michael J" <michael.j.ruhl@intel.com>
Subject: RE: [PATCH rdma-next v2 01/13] IB/uverbs: Add an ib_uobject getter
 to ioctl() infrastructure
Date: Tue, 29 May 2018 20:49:58 +0000
Message-ID: <14063C7AD467DE4B82DEDB5C278E8663B38EE87B@FMSMSX108.amr.corp.intel.com>
References: <20180529130917.13592-1-leon@kernel.org>
 <20180529130917.13592-2-leon@kernel.org>
 <14063C7AD467DE4B82DEDB5C278E8663B38ED738@FMSMSX108.amr.corp.intel.com>
 <20180529202119.GK18442@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180529202119.GK18442@mellanox.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Boris Pismenny <borisp@mellanox.com>, Matan Barak <matanb@mellanox.com>, Raed Salem <raeds@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

>-----Original Message-----
>From: Jason Gunthorpe [mailto:jgg@mellanox.com]
>Sent: Tuesday, May 29, 2018 4:21 PM
>To: Ruhl, Michael J <michael.j.ruhl@intel.com>
>Cc: Leon Romanovsky <leon@kernel.org>; Doug Ledford
><dledford@redhat.com>; Leon Romanovsky <leonro@mellanox.com>; RDMA
>mailing list <linux-rdma@vger.kernel.org>; Boris Pismenny
><borisp@mellanox.com>; Matan Barak <matanb@mellanox.com>; Raed
>Salem <raeds@mellanox.com>; Yishai Hadas <yishaih@mellanox.com>; Saeed
>Mahameed <saeedm@mellanox.com>; linux-netdev
><netdev@vger.kernel.org>
>Subject: Re: [PATCH rdma-next v2 01/13] IB/uverbs: Add an ib_uobject getter
>to ioctl() infrastructure
>
>On Tue, May 29, 2018 at 07:31:22PM +0000, Ruhl, Michael J wrote:
>> >-	struct ib_uverbs_destroy_cq_resp resp;
>> > 	struct ib_uobject *uobj =
>> >-		uverbs_attr_get(attrs,
>> >UVERBS_ATTR_DESTROY_CQ_HANDLE)->obj_attr.uobject;
>> >-	struct ib_ucq_object *obj = container_of(uobj, struct ib_ucq_object,
>> >-						 uobject);
>> >+		uverbs_attr_get_uobject(attrs,
>> >UVERBS_ATTR_DESTROY_CQ_HANDLE);
>> >+	struct ib_uverbs_destroy_cq_resp resp;
>> >+	struct ib_ucq_object *obj;
>> > 	int ret;
>> >
>> >+	if (IS_ERR(uobj))
>> >+		return PTR_ERR(uobj);
>> >+
>>
>> I remember a conversation that if an method attribute was mandatory, that
>you did not need to
>> test the uobj for error (since it was checked in the infrastructure).
>
>Yes.
>
>> Is this error check necessary?
>
>No
>
>But there is no way to check one way or the other at compile time
>right now, and omitting the check makes smatch mad.

Is smatch going to get mad at (same patch):

diff --git a/drivers/infiniband/core/uverbs_std_types_flow_action.c b/drivers/infiniband/core/uverbs_std_types_flow_action.c
index b4f016dfa23d..a7be51cf2e42 100644
--- a/drivers/infiniband/core/uverbs_std_types_flow_action.c
+++ b/drivers/infiniband/core/uverbs_std_types_flow_action.c
@@ -320,7 +320,7 @@ static int UVERBS_HANDLER(UVERBS_METHOD_FLOW_ACTION_ESP_CREATE)(struct ib_device
 		return ret;

 	/* No need to check as this attribute is marked as MANDATORY */
-	uobj = uverbs_attr_get(attrs, UVERBS_ATTR_FLOW_ACTION_ESP_HANDLE)->obj_attr.uobject;
+	uobj = uverbs_attr_get_uobject(attrs, UVERBS_ATTR_FLOW_ACTION_ESP_HANDLE);
 	action = ib_dev->create_flow_action_esp(ib_dev, &esp_attr.hdr, attrs);
 	if (IS_ERR(action))
 		return PTR_ERR(action);
@@ -350,7 +350,7 @@ static int UVERBS_HANDLER(UVERBS_METHOD_FLOW_ACTION_ESP_MODIFY)(struct ib_device
 	if (ret)
 		return ret;

-	uobj = uverbs_attr_get(attrs, UVERBS_ATTR_FLOW_ACTION_ESP_HANDLE)->obj_attr.uobject;
+	uobj = uverbs_attr_get_uobject(attrs, UVERBS_ATTR_FLOW_ACTION_ESP_HANDLE);
 	action = uobj->object;

?

If not,

Reviewed-by: Michael J. Ruhl <michael.j.ruhl@intel.com>

Thanks,

Mike

>We need some more patches to be able to safely omit the check...
>
>Jason
