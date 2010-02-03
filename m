From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 0/8] ib/iser: major face lift of the data path code
Date: Wed, 3 Feb 2010 17:10:58 +0100
Message-ID: <e2e108261002030810r432072e1ia8fce2f163f08e28@mail.gmail.com>
References: <Pine.LNX.4.64.1002031721280.11944@zuben.voltaire.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/alternative; boundary=001636c5be5ec50636047eb476e1
Return-path: <3GaBpSw4JCm4NMdf.hMZMeeOTQSYMUX.OaYabQZ-UeOeUSaaSXQSdagbe.OaY-WNnxsJb2WYALHLMFiseIBxPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
In-Reply-To: <Pine.LNX.4.64.1002031721280.11944-aDiYczhfhVLdX2U7gxhm1tBPR1lH4CV8@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post?hl=en_US>,
	<mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/?hl=en_US>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi?hl=en_US>
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
	<mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
	<mailto:open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--001636c5be5ec50636047eb476e1
Content-Type: text/plain; charset=ISO-8859-1

On Wed, Feb 3, 2010 at 4:30 PM, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org> wrote:

> The following patch set removes some in efficiencies in the iser data path
> through simplification and reducing the amount of code, using less atomic
> operations, avoiding TX interrupts, moving to iscsi passthrough mode,
> etc. I did my best to build it as a sequence of patches and not as one
> big re-write, to allow for better debugging (e.g bisection) and tuning.
>
> Or.
>
> [PATCH 01/9] ib/iser: revert commit bba7ebb "avoid recv buffer exhaustion"
> [PATCH 02/9] ib/iser: new recv buffer posting logic
> [PATCH 03/9] ib/iser: remove atomic counter for posted recv buffers
> [PATCH 04/9] ib/iser: use different CQ for send completions
> [PATCH 05/9] ib/iser: simplify send flow/descriptors
> [PATCH 06/9] ib/iser: use atomic allocations
> [PATCH 07/9] ib/iser: remove unnecessary connection checks
> [PATCH 08/9] ib/iser: move to use libiscsi passthrough mode
> [PATCH 09/9] ib/iser: remove redundant locking from iser scsi command
> response flow
>

Sounds really interesting. Do you have numbers available about how much
these patches improve throughput or decrease latency ?

Bart.

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To unsubscribe from this group, send email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
For more options, visit this group at http://groups.google.com/group/open-iscsi?hl=en.


--001636c5be5ec50636047eb476e1
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div class=3D"gmail_quote">On Wed, Feb 3, 2010 at 4:30 PM, Or Gerlitz <span=
 dir=3D"ltr">&lt;<a href=3D"mailto:ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org">ogerlitz@voltaire=
.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"ma=
rgin: 0pt 0pt 0pt 0.8ex; border-left: 1px solid rgb(204, 204, 204); padding=
-left: 1ex;">
The following patch set removes some in efficiencies in the iser data path<=
br>
through simplification and reducing the amount of code, using less atomic<b=
r>
operations, avoiding TX interrupts, moving to iscsi passthrough mode,<br>
etc. I did my best to build it as a sequence of patches and not as one<br>
big re-write, to allow for better debugging (e.g bisection) and tuning.<br>
<br>
Or.<br>
<br>
[PATCH 01/9] ib/iser: revert commit bba7ebb &quot;avoid recv buffer exhaust=
ion&quot;<br>
[PATCH 02/9] ib/iser: new recv buffer posting logic<br>
[PATCH 03/9] ib/iser: remove atomic counter for posted recv buffers<br>
[PATCH 04/9] ib/iser: use different CQ for send completions<br>
[PATCH 05/9] ib/iser: simplify send flow/descriptors<br>
[PATCH 06/9] ib/iser: use atomic allocations<br>
[PATCH 07/9] ib/iser: remove unnecessary connection checks<br>
[PATCH 08/9] ib/iser: move to use libiscsi passthrough mode<br>
[PATCH 09/9] ib/iser: remove redundant locking from iser scsi command respo=
nse flow<br></blockquote><div><br>Sounds really interesting. Do you have nu=
mbers available about how much these patches improve throughput or decrease=
 latency ?<br>
<br>Bart. <br></div></div>

<p></p>

-- <br />

You received this message because you are subscribed to the Google Groups "=
open-iscsi" group.<br />

To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org<br />

To unsubscribe from this group, send email to open-iscsi+unsubscribe@google=
groups.com.<br />

For more options, visit this group at http://groups.google.com/group/open-i=
scsi?hl=3Den.<br />


--001636c5be5ec50636047eb476e1--
