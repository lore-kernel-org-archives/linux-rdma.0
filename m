From: "Bernard Metzler" <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Subject: Re: [PATCH v2 04/13] SoftiWarp object management
Date: Sat, 14 Oct 2017 00:34:54 +0000
Message-ID: <OF63CFAB2B.E50348C5-ON002581B9.0003321F-002581B9.00033224@notes.na.collabserv.com>
References: <a82cc3b1-af27-c1de-afb1-a8edea4baed2@redhat.com>,<20171006122853.16310-1-bmt@zurich.ibm.com>
 <20171006122853.16310-5-bmt@zurich.ibm.com>
 <20171008122839.GS25829@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <a82cc3b1-af27-c1de-afb1-a8edea4baed2-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

-----Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote: -----

>To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Bernard Metzler
><bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
>From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>Date: 10/13/2017 03:01AM
>Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>Subject: Re: [PATCH v2 04/13] SoftiWarp object management
>
>On 10/8/2017 8:28 AM, Leon Romanovsky wrote:
>>> +	} else if (id == -ENOSPC && pre_id != 1) {
>>> +		pre_id = 1;
>>> +		goto again;
>>> +	} else {
>>> +		BUG_ON(id == 0);
>> No BUG_ON in new code.
>> 
>>> +		dprint(DBG_OBJ|DBG_ON, "(OBJ??): IDR New Object failed!\n");
>>> +	}
>>> +	return id > 0 ? 0 : id;
>>> +}
>
>Not to mention that this segment displays why BUG_ON() is so bad.
>You
>have issued a BUG_ON() and then on the very next line you have a
>dprint() as if there is anything else that happens after a BUG_ON().
>There isn't.  By definition, with a BUG_ON(), you have killed the
>entire
>machine.  You will never get to the dprint() line, it is completely
>unreachable code.  Unless you run across something the likes of a
>hardware device that is completely out of control, that is DMAing to
>random address, and that you can't stop, BUG_ON is not an appropriate
>solution.  You should only BUG_ON if continuing to run will render
>the
>machine randomly corrupted and jeopardize writing that corruption to
>disk and wiping the persistent system data out.  Short of that, you
>need
>to find a way to gracefully handle the situation and continue.  It
>may
>mean shutting your device down forcefully so that the rest of the
>machine may live, but that's OK.  Shutting the entire machine down is
>not.
>
>-- 
>Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>    GPG Key ID: B826A3330E572FDD
>    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57
>2FDD
>
>
[attachment "signature.asc" removed by Bernard Metzler/Zurich/IBM]

Hi Doug,

Thanks for finding that. Its a bug in my code - besides of using the BUG()
statement. I am aware that BUG() eventually halts the machine.

Thank you!
Bernard.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
