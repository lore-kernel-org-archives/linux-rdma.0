From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-next 02/13] IB/core: Add support to finalize objects
 in one transaction
Date: Thu, 29 Jun 2017 19:41:32 +0300
Message-ID: <CAAKD3BBEx-zgvttx7U5DqRP4828qiA8pmEw72q4GZGf5-dEBfQ@mail.gmail.com>
References: <1496838172-39671-1-git-send-email-matanb@mellanox.com>
 <1496838172-39671-3-git-send-email-matanb@mellanox.com> <1828884A29C6694DAF28B7E6B8A82373AB141A91@ORSMSX109.amr.corp.intel.com>
 <CAAKD3BCpRwiCejxuKiP07q-jGoRF1W8Ovs5aMt07uO2gAc1Qug@mail.gmail.com> <37c8c95b-eec5-af5c-8d72-eea429d84818@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <37c8c95b-eec5-af5c-8d72-eea429d84818-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 21, 2017 at 6:33 PM, Dennis Dalessandro
<dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> On 6/11/2017 4:16 AM, Matan Barak wrote:
>>
>> On Fri, Jun 9, 2017 at 2:51 AM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>>>>
>>>> The new ioctl based infrastructure either commits or rollbacks
>>>> all objects of the command as one transaction. In order to do
>>>> that, we introduce a notion of dealing with a collection of
>>>> objects that are related to a specific action.
>>>>
>>>> This also requires adding a notion of an action and attribute.
>>>> An action contains a groups of attributes, where each group
>>>> contains several attributes.
>>>>
>>>> For example, an object could be a CQ, which has an action of
>>>> CREATE_CQ.
>>>> This action has multiple attributes. For example, the CQ's new handle
>>>> and the comp_channel. Each layer in this hierarchy - objects, actions
>>>> and attributes is split into groups. The common example for that is
>>>> one group representing the common entities and another one
>>>> representing the driver specific entities.
>>>>
>>>> When declaring these actions and attributes, we actually declare
>>>> their specifications. When a command is executed, we actually
>>>> allocates some space to hold auxiliary information. This auxiliary
>>>> information contains meta-data about the required objects, such
>>>> as pointers to their type information, pointers to the uobjects
>>>> themselves (if exist), etc.
>>>> The specification, along with the auxiliary information we allocated
>>>> and filled is given to the finalize_objects function.
>>>>
>>>> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>>> Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>>> ---
>>>>   drivers/infiniband/core/rdma_core.c | 39
>>>> ++++++++++++++++++++++++++++++
>>>>   drivers/infiniband/core/rdma_core.h | 22 ++++++++++++++++-
>>>>   include/rdma/uverbs_ioctl.h         | 48
>>>> +++++++++++++++++++++++++++++++++++++
>>>>   3 files changed, 108 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/infiniband/core/rdma_core.c
>>>> b/drivers/infiniband/core/rdma_core.c
>>>> index 2bd58ff..3d3cf07 100644
>>>> --- a/drivers/infiniband/core/rdma_core.c
>>>> +++ b/drivers/infiniband/core/rdma_core.c
>>>> @@ -683,3 +683,42 @@ int uverbs_finalize_object(struct ib_uobject
>>>> *uobj,
>>>>
>>>>        return ret;
>>>>   }
>>>> +
>>>> +int uverbs_finalize_objects(struct uverbs_attr_array *attr_array,
>>>> +                         struct uverbs_attr_spec_group ** const
>>>> spec_groups,
>>>> +                         size_t num,
>>>> +                         bool commit)
>>>> +{
>>>> +     unsigned int i;
>>>> +     int ret = 0;
>>>> +
>>>> +     for (i = 0; i < num; i++) {
>>>> +             struct uverbs_attr_array *attr_group_array =
>>>> &attr_array[i];
>>>> +             const struct uverbs_attr_spec_group *attr_spec_group =
>>>> +                     spec_groups[i];
>>>> +             unsigned int j;
>>>> +
>>>> +             for (j = 0; j < attr_group_array->num_attrs; j++) {
>>>> +                     struct uverbs_attr *attr;
>>>> +                     struct uverbs_attr_spec *spec;
>>>> +
>>>> +                     if (!uverbs_is_valid(attr_group_array, j))
>>>> +                             continue;
>>>> +
>>>> +                     attr = &attr_group_array->attrs[j];
>>>> +                     spec = &attr_spec_group->attrs[j];
>>>> +
>>>> +                     if (spec->type == UVERBS_ATTR_TYPE_IDR ||
>>>> +                         spec->type == UVERBS_ATTR_TYPE_FD) {
>>>> +                             int current_ret;
>>>> +
>>>> +                             current_ret = uverbs_finalize_object(attr-
>>>>>
>>>>> obj_attr.uobject,
>>>>
>>>> +
>>>> spec->obj.access,
>>>> +
>>>> commit);
>>>> +                             if (!ret)
>>>> +                                     ret = current_ret;
>>>> +                     }
>>>> +             }
>>>> +     }
>>>> +     return ret;
>>>> +}
>>>> diff --git a/drivers/infiniband/core/rdma_core.h
>>>> b/drivers/infiniband/core/rdma_core.h
>>>> index 97483d1..5cc00eb 100644
>>>> --- a/drivers/infiniband/core/rdma_core.h
>>>> +++ b/drivers/infiniband/core/rdma_core.h
>>>> @@ -82,7 +82,8 @@
>>>>    * applicable.
>>>>    * This function could create (access == NEW), destroy (access ==
>>>> DESTROY)
>>>>    * or unlock (access == READ || access == WRITE) objects if required.
>>>> - * The action will be finalized only when uverbs_finalize_object is
>>>> called.
>>>> + * The action will be finalized only when uverbs_finalize_object or
>>>> + * uverbs_finalize_objects are called.
>>>>    */
>>>>   struct ib_uobject *uverbs_get_uobject_from_context(const struct
>>>> uverbs_obj_type *type_attrs,
>>>>                                                   struct ib_ucontext
>>>> *ucontext,
>>>> @@ -91,5 +92,24 @@ struct ib_uobject
>>>> *uverbs_get_uobject_from_context(const struct uverbs_obj_type
>>>>   int uverbs_finalize_object(struct ib_uobject *uobj,
>>>>                           enum uverbs_obj_access access,
>>>>                           bool commit);
>>>> +/*
>>>> + * Note that certain finalize stages could return a status:
>>>> + *   (a) alloc_commit could return a failure if the object is
>>>> committed at the
>>>> + *       same time when the context is destroyed.
>>>> + *   (b) remove_commit could fail if the object wasn't destroyed
>>>> successfully.
>>>> + * Since multiple objects could be finalized in one transaction, it
>>>> is very NOT
>>>> + * recommended to have several finalize actions which have side
>>>> effects.
>>>> + * For example, it's NOT recommended to have a certain action which
>>>> has both
>>>> + * a commit action and a destroy action or two destroy objects in the
>>>> same
>>>> + * action. The rule of thumb is to have one destroy or commit action
>>>> with
>>>> + * multiple lookups.
>>>> + * The first non zero return value of finalize_object is returned
>>>> from this
>>>> + * function. For example, this could happen when we couldn't destroy
>>>> an
>>>> + * object.
>>>> + */
>>>> +int uverbs_finalize_objects(struct uverbs_attr_array *attr_array,
>>>> +                         struct uverbs_attr_spec_group ** const
>>>> spec_groups,
>>>> +                         size_t num,
>>>> +                         bool commit);
>>>>
>>>>   #endif /* RDMA_CORE_H */
>>>> diff --git a/include/rdma/uverbs_ioctl.h b/include/rdma/uverbs_ioctl.h
>>>> index 4ff87ee..e06f4cf 100644
>>>> --- a/include/rdma/uverbs_ioctl.h
>>>> +++ b/include/rdma/uverbs_ioctl.h
>>>> @@ -41,6 +41,12 @@
>>>>    * =======================================
>>>>    */
>>>>
>>>> +enum uverbs_attr_type {
>>>> +     UVERBS_ATTR_TYPE_NA,
>>>> +     UVERBS_ATTR_TYPE_IDR,
>>>> +     UVERBS_ATTR_TYPE_FD,
>>>> +};
>>>> +
>>>>   enum uverbs_obj_access {
>>>>        UVERBS_ACCESS_READ,
>>>>        UVERBS_ACCESS_WRITE,
>>>> @@ -48,5 +54,47 @@ enum uverbs_obj_access {
>>>>        UVERBS_ACCESS_DESTROY
>>>>   };
>>>>
>>>> +struct uverbs_attr_spec {
>>>> +     enum uverbs_attr_type           type;
>>>> +     struct {
>>>> +             /*
>>>> +              * higher bits mean the group and lower bits mean
>>>> +              * the type id within the group.
>>>> +              */
>>>> +             u16                     obj_type;
>>>
>>>
>>> Why aren't separate fields used instead of an unspecified bit separation?
>>>
>>>
>>
>> The "spec" part isn't passed from user-space to kernel. It's intended
>> to instruct the kernel parser how to parse the command.
>> Since these structs are parsed automatically and built using macros, I
>> was in favor of reducing the .text section size here.
>
>
> My opinion is splitting would make the code nicer to read, but if it's
> really only ever touched using macros I guess that's not too big of a deal.
> I hardly think the .text section size here is really that big of a concern
> given all the other stuff we are going to be cramming in.
>

Currently bunch of macros just build these stuff for the developer, so
I think it's reasonable.
We could have a simple xxxx_to_string function to print it correctly.

> -Denny

Matan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
