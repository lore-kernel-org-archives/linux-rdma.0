From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next V5 1/5] IB/uverbs: Fix reference counting usage
 of event files
Date: Thu, 25 Jun 2015 11:52:28 -0600
Message-ID: <20150625175228.GF21033@obsidianresearch.com>
References: <1434984438-21733-1-git-send-email-yishaih@mellanox.com>
 <1434984438-21733-2-git-send-email-yishaih@mellanox.com>
 <20150624175738.GC21033@obsidianresearch.com>
 <558BE9FA.9060402@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <558BE9FA.9060402-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 25, 2015 at 02:46:02PM +0300, Yishai Hadas wrote:
> On 6/24/2015 8:57 PM, Jason Gunthorpe wrote:
> >On Mon, Jun 22, 2015 at 05:47:14PM +0300, Yishai Hadas wrote:
> >>  	fd_install(resp.async_fd, filp);
> >>@@ -386,6 +376,7 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
> >>  	return in_len;
> >>
> >>  err_file:
> >>+	ib_uverbs_free_async_event_file(file);
> >>  	fput(filp);
> >
> >This looks really weird.
> 
> We need to cleanup all by that step otherwise we might leak that async file,
> see my last comment below which clarifies that point.
> As ib_uverbs_release_event_file is static function in uverbs_main it makes
> sense to expose this cleanup function similar to ib_uverbs_alloc_event_file
> which is exposed from uverbs_main and make the allocation.

Okay, sure, that makes sense.

> >Again again, WTF? async_file is a kref'd thing, if you copy or assign
> >to it you need to manipulate the kref, so the null assign should be
> >dropping the ref.
>
> The logic in ib_uverbs_alloc_event_file if kref oriented, the original code
> which uses free didn't follow this convention, currently in case

Yes, and you fixed it, this is good:

@@ -557,15 +563,38 @@  struct file *ib_uverbs_alloc_event_file(struct ib_uverbs_file *uverbs_file,
	ev_file = kmalloc(sizeof *ev_file, GFP_KERNEL);
	kref_init(&ev_file->ref);
        if (IS_ERR(filp))
+		goto err;
+err:
+	kref_put(&ev_file->ref, ib_uverbs_release_event_file);

The kref_init and the kref_put are a matching pair, great!

> had an error after that the file was created (e.g ib_register_event_handler)
> need to use fput(filp) to make an extra cleanup which again uses ref count
> handling.

Yep, that is a good idea too. But understand what it means,

When this happens:
 	filp = anon_inode_getfile("[infinibandevent]", &uverbs_event_fops,
 				  ev_file, O_RDONLY);
The unref pairs for these gets:
	kref_init(&ev_file->ref);
+	kref_get(&uverbs_file->ref);

Are logically moved into flip, and now fput(flip) will call
ib_uverbs_event_close() and both those krefs will be released.

For this reason, for clarity, I would also move the
'kref_get(&uverbs_file->ref);' to be before anon_inode_getfile()

Which means this:

@@ -557,15 +563,38 @@  struct file *ib_uverbs_alloc_event_file(struct ib_uverbs_file *uverbs_file,
+	kref_get(&uverbs_file->ref);
+	if (is_async) {
+		if (ret)
+			goto put_file;
+put_file:
+	fput(filp);
+err:
+	kref_put(&ev_file->ref, ib_uverbs_release_event_file);

Is a double put on ev_file, since fput -> ib_uverbs_event_close does one, and
then err does another. (remember, the ref was moved into the flip)

Next:

+	if (is_async) {
+		uverbs_file->async_file = ev_file;
+		kref_get(&uverbs_file->async_file->ref);
+		if (ret)
+			goto put_file;
+put_file:
+	uverbs_file->async_file = NULL;

Where is the paired kref_put? There are two I can see:

+void ib_uverbs_free_async_event_file(struct ib_uverbs_file *file)
+{
+	kref_put(&file->async_file->ref, ib_uverbs_release_event_file);
-----
static int ib_uverbs_close(struct inode *inode, struct file *filp)
		kref_put(&file->async_file->ref, ib_uverbs_release_event_file);

As far as I can tell, neither of these are called, so we have an
unbalanced put.

Which brings me back to my statement:

> >Again again, WTF? async_file is a kref'd thing, if you copy or assign
> >to it you need to manipulate the kref, so the null assign should be
> >dropping the ref.

So, the two possible fixes are
1) Make the call to ib_uverbs_free_async_event_file() happen even if
   ib_uverbs_alloc_event_file() fails
2) Do in ib_uverbs_alloc_event_file
+	kref_put(&uverbs_file->async_file->ref, ib_uverbs_release_event_file);
+	uverbs_file->async_file = NULL;
   Which may as well just be a call to ib_uverbs_free_async_event_file()

In either situation the naked async_file = NULL is fixed to have a
kref beside it.

This is basic invariant of how kref works. Read the 'rules' in
Documentation/kref.txt

So, as I reviewer, I see a kref'd variable (async_file) being
manipulated without corresponding kref code. I *KNOW* something is
wrong. You answer didn't address this, you needed to ID where the
pair'd kref_put was and justify having the '= NULL' so far away from
it.

> >Whis looks good enough to remove ib_uverbs_free_async_event_file, if
> >the flip is created OK then the uverbs_file->async file can remain set
> >until the uverbs file is closed.
> 
> This is wrong, as file->ucontext is NULL because of the failure in
> copy_to_user, application might recall to ib_uverbs_get_context in that case
> we leak that previous async_file, that's why the code must cleanup and put
> NULL by that step. To your request put WARN_ON(uverbs_file->async_file) as
> part of ib_uverbs_alloc_event_file to make sure that we don't hit that case.

Yes, that makes sense.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
