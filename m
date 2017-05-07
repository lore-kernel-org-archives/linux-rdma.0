From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH RFC 02/10] IB/core: Add support to finalize objects in one transaction
Date: Sun, 7 May 2017 15:39:32 +0300
Message-ID: <CAAKD3BAr0GX5rGCq_wcxQ=NKZwyHdrvnj_3G25mhq-c1qqFFRQ@mail.gmail.com>
References: <1492615225-55118-1-git-send-email-matanb@mellanox.com>
 <1492615225-55118-3-git-send-email-matanb@mellanox.com> <SN1PR07MB22077A1B43881BAF7BAC5ED0F8EA0@SN1PR07MB2207.namprd07.prod.outlook.com>
 <CAAKD3BBfZa_eM2L+LE30uDnoEge6rCBj17YtkVZULUsKMQrQww@mail.gmail.com> <BN3PR07MB2578868B660CC388664BE501F8E90@BN3PR07MB2578.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BN3PR07MB2578868B660CC388664BE501F8E90-EldUQEzkDQfpW3VS/XPqkOFPX92sqiQdvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, May 7, 2017 at 3:02 PM, Amrani, Ram <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org> wrote:
>> >> The new ioctl based infrastructure either commits or rollbacks
>> >> all objects of the command as one transaction. In order to do
>> >> that, we introduce a notion of dealing with a collection of
>> >> objects that are related to a specific action.
>> >>
>> >> This also requires adding a notion of an action and attribute.
>> >> An action contains a groups of attributes, where each group
>> >> contains several attributes.
>> >>
>> >> When declaring these actions and attributes, we actually declare
>> >> their specifications. When a command is executed, we actually
>> >> allocates some space to hold auxiliary information.
>> >>
>> >> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> >> ---
>> >
>> > Matan, thanks for the RFC!
>> >
>> > If I got this correctly each object will go through three phases - get, handler, and a put.
>> > I don't quite understand how a batch operation, like destroy QPs, can be undone after the handler phase.
>> > I do see it working if at first multiple gets are performed and one of them fails.
>> > In that case undoing is easy because the handlers weren't invoked yet.
>> >
>> > In the case were some user-objects failed the operation how is this reflected upwards?
>> >
>> > Also, I wonder, is there another intention behind batch operations except speed?
>> >
>>
>> It's really not recommended to batch create/destroy. The reason is
>> exactly what you've pointer out.
>> If you batch several "destroy objects" and the n'th one fail, you
>> can't unwind the successful ones.
>>
>> So basically, we want to support a semantic which is similar to what
>> we have today - create a single object or destroy a single object.
>> In this case, the pre-handler stage locks the dependencies of this
>> object (for example, in create_qp you lock the pd and cq so they won't
>> be destroyed)
>> and create the uobject for the QP. The handler itself can assume the
>> requirements it stated in the specifications are filled and just
>> create the QP and
>> tie the uobject to the QP object. In the post-handler stage we commit
>> the QP's uobject and unlock the dependencies (assuming the handler
>> increased
>> the required refcounts).
>> Destroying an object is similar. The only different is that the
>> destruction itself isn't done by the handler, but in the
>> post-handler's code (to share this code between
>> regular "destroy" calls with process tear-down and hardware removal).
>
> I understand there are two sets of objects here. Let's make sure I'm not confusing them.
>
> (1) A collection of user-objects passed via ioctl. This is indicated in the first paragraph.
> But as you indicated now we shouldn't support this. So why (apparently) do we?
>
> (2) A collection of user-objects that should be locked for the creation/deletion/modification
> of another that was requested via ioctl.
> In this case the handler doesn't need to be invoked at all for the collection.
> We can easily roll back the "get" phase, if failed during.
> We don't expect the "put" phase to fail, if it will fail for some reason. Then this won't really
> be handled as the handler was already invoked.
>

The infrastructure is agnostic to whether the objects are common or
driver specific.
It actually gives you a (hopefully) convenient way to invoke verbs
handlers in the kernel.
Each handler is a function which could have some arguments. However,
we can't pass kernel pointers
from user-space to kernel and we can't trust the user-space from
executing two calls concurrently that
could use an object and destroy it at the same time. Currently
(current infrastructure), when you write such a handler, you need
to open code this yourself - map ids to objects and lock them.

What we propose here is to have some additional info to the handler.
This info could be thought as the function's deceleration.
This additional info makes the infrastructure validates syntactically
your attributes, map them to the actual kernel pointers and lock them.
Since the kernel developer writes this "additional info"
(specification), it can make sure only one "DESTROY" or "CREATE"
object exists per a specification (to avoid the behavior you
mentioned).

A command handling always consists of 3 stages: pre, handler and post
(for all handlers).
So, overall, if you have a create based command, the "pre" stage
creates the uobject and locks its dependencies. If the handler fails,
this is totally reversible (unlock dependencies and destroy the
uobject).
If you have a destroy command, the "pre" stage locks the uobject for
exclusive access. If the handler fails, it just unlocks the object. If
it's successful, the "post" stage actually destroys it.
In other commands, the "pre" stage just locks the uobjects and
obviously it's reversible.

I hope that answers your questions.

> Thanks,
> Ram
>
>

- Matan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
