From: Martin Schwidefsky <schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/3] s390/kernel: add system calls for access PCI memory
Date: Mon, 13 Oct 2014 10:39:45 +0200
Message-ID: <20141013103945.27be11ef@mschwide>
References: <1412933657-52641-1-git-send-email-aishchuk@linux.vnet.ibm.com>
 <1412933657-52641-2-git-send-email-aishchuk@linux.vnet.ibm.com>
 <f061a36c713c42c9b71530183a6e8644@AMSPR05MB422.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f061a36c713c42c9b71530183a6e8644-Vl31pUvGNwELId+1UC+8EGu6+pknBqLbXA4E9RH9d+qIuWR1G4zioA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Alexey Ishchuk <aishchuk-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "blaschka-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org" <blaschka-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "gmuelas-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org" <gmuelas-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, "utz.bacher-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org" <utz.bacher-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alexey Ishchuk <alexey_ishchuk-JgLE2wv1ufrQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, 12 Oct 2014 11:52:55 +0000
Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:

> > +	switch (length) {
> > +	case 1:
> > +		ret = get_user(value.buf8, ((u8 *)user_buffer));
> 
> This cast (and similar casts across the code) kills the __user
> annotation of the user buffer pointer.
> First - fix this to help various static verification tools such
> as sparse work on your code.
> Second - are you sure this switch-case block achieves any
> performance gain compared to always using copy_from_user?
> If so, why not just push it into the S390 copy from user code?

The __user annotation is indeed missing. If the switch is improving
performance needs to be seen, with the compile options set for z10
the get_user is inlined while the copy_from_user calls a function.
For compiles < z10 all 5 switch cases will call the same
__copy_from_user function. So it depends, as long as the switch is
correct I am ok the code block for now.
 
> > +	switch (length) {
> > +	case 1:
> > +		value.buf8 = __raw_readb(io_addr);
> > +		ret = put_user(value.buf8, ((u8 *)user_buffer));
> 
> Add __user annotations in this code block as well.

Yes, please add.

> Generally speaking, looks OK once the __user annotation is added.
> 
> I suspect you might need ack/review from the S390 maintainer as
> well for this to be pushed, as the syscall is generic to the
> entire S390 subsystem.

With the missing __user annotations added:
Acked-by: Martin Schwidefsky <schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
