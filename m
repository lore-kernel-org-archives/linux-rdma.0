From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V1 for-next 6/7] IB/core: Add support for fd objects
Date: Sun, 19 Feb 2017 14:47:02 +0200
Message-ID: <CAAKD3BD-Uyg9bN=EaB3GbqhaKsKUszKXD6YaVAUxBp8cQcJgbQ@mail.gmail.com>
References: <1485952745-58476-1-git-send-email-matanb@mellanox.com>
 <1485952745-58476-7-git-send-email-matanb@mellanox.com> <20170210210350.GE4335@obsidianresearch.com>
 <CAAKD3BDbQVfC06Kzud=j=+a32YFxwcxrqm41SyhL0uWXm0O0Hw@mail.gmail.com> <20170215185448.GE19162@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170215185448.GE19162-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 15, 2017 at 8:54 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Wed, Feb 15, 2017 at 03:48:40PM +0200, Matan Barak wrote:
>> >> +static struct ib_uobject *lookup_get_fd_uobject(const struct uverbs_obj_type *type,
>> >> +                                             struct ib_ucontext *ucontext,
>> >> +                                             int id, bool write)
>> >> +{
>> >> +     struct file *f;
>> >> +     struct ib_uobject *uobject;
>> >> +     const struct uverbs_obj_fd_type *fd_type =
>> >> +             container_of(type, struct uverbs_obj_fd_type, type);
>> >> +
>> >> +     if (write)
>> >> +             return ERR_PTR(-EOPNOTSUPP);
>> >> +
>> >> +     f = fget(id);
>> >> +     if (!f)
>> >> +             return ERR_PTR(-EBADF);
>> >> +
>> >> +     uobject = f->private_data;
>> >> +     if (f->f_op != fd_type->fops ||
>> >> +         !uobject->context) {
>> >> +             fput(f);
>> >> +             return ERR_PTR(-EBADF);
>> >> +     }
>> >
>> > The read of uobject->context needs locking
>> >
>>
>> All these callbacks are assumed to run when the context is alive.
>
> 'uboject->context' is touched outside the SRCU, eg in
> uverbs_close_fd() - so it absolutely needs locking.
>

uobject->context isn't protected by SRCU as intended.
lookup_get_fd_uobject can't be
executed concurrently with uverbs_close_fd, as uverbs_close_fd is
called when the
last reference of the fd is put and in that case fget called by
lookup_get_fd_uobject
would simply fail. Since fput and fget are atomically safe, this should be safe.

>> The only call we allow the user to execute while this is in process
>> is uverbs_close_fd and that's why this is the only call which is
>> protected by the cleanup_mutex.
>
> So cleanup_mutex would need to be held during lookup
>

You can't run lookup_get and uverbs_close_fd concurrently as stated above.

Regarding the locking, assuming uverbs_close_fd is called from the
release file operation and SRCU
protects us (as currently implemented), we don't see locking issues here.

Yishai and Matan.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
