From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 03/14] ib_srp: Disallow duplicate logins
Date: Sun, 18 Dec 2011 19:20:42 +0000
Message-ID: <CAO+b5-r6dHt-vmbNjeD4zvcAaRVqhiEm5eZF7hgF6ei35kqjdQ@mail.gmail.com>
References: <201112011954.25811.bvanassche@acm.org>
	<201112011958.17339.bvanassche@acm.org>
	<1323976101.16703.42.camel@lap75545.ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1323976101.16703.42.camel-FqX9LgGZnHWDB2HL1qBt2PIbXMQ5te18@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 15, 2011 at 7:08 PM, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org> wrote=
:
> On Thu, 2011-12-01 at 19:58 +0100, Bart Van Assche wrote:
> > Currently the ib_srp driver allows to log in multiple times to the
> > same target via its sysfs interface. This leads to each target LUN
> > being imported multiple times at the initiator side, something that
> > should not be allowed.
>
> I'm of mixed opinion on this one. It seems like we're working around =
a
> broken target -- we request single RDMA channel operation in our logi=
n
> requests, so the standard says that the target should disconnect all
> other connections for that I_T nexus when it receives a new login
> request. That should keep us from having multiple instances of LUNs f=
rom
> the same target over a single srp_host (HCA).
>
> In the past, we've seen connections having issues but not going away,
> and the only way to kill them was to create a new connection to the R=
AID
> controller, which would then kill the old one. It's been a few years
> since I've seen this, so the details are a bit fuzzy, but I recall th=
e
> current behavior being useful.
>
> However, I'm not adverse to going beyond the standard if it makes sen=
se,
> and your later patch to allow disconnecting channels without removing
> the module would fix the use case above. What problem are we solving
> here other than a potentially confused admin?

I agree that relogin is a useful feature. But I doubt the way it works
now is fine because during a certain time window all LUNs appear twice
at the initiator side - half of them working, half of them not.
Relogin is still possible with this patch set, but it requires an
extra step: deleting a target before attempting to log in again.

> > + =A0 =A0 spin_lock(&host->target_lock);
> > + =A0 =A0 list_for_each_entry(t, &host->target_list, list) {
> > + =A0 =A0 =A0 =A0 =A0 =A0 WARN_ON(t =3D=3D target);
> > + =A0 =A0 =A0 =A0 =A0 =A0 if (target->id_ext =3D=3D t->id_ext &&
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 target->ioc_guid =3D=3D t->ioc_gu=
id &&
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcmp(target->orig_dgid, t->orig=
_dgid, 16) =3D=3D 0 &&
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 target->path.pkey =3D=3D t->path.=
pkey &&
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 target->service_id =3D=3D t->serv=
ice_id) {
>
> The spec discusses the I_T nexus defined by the initiator and target
> port identifiers as the unit for disambiguation when running in singl=
e
> channel mode. The initiator port identifier is controlled by the port=
's
> GUID combined with target->initiator_ext and the target port identifi=
er
> is defined by target->{id_ext,ioc_guid}.
>
> From the standard's perspective, why should we care about pkey, dgid =
(or
> orig_dgid as above) or the service id? Those don't change the I_T nex=
us,
> so the target should disconnect previous channels appropriately.

I'm fine with leaving out the PKey and the service ID. But I'm not
sure it's fine to leave the DGID out because leaving out the DGID will
prevent setting up redundant connections from an initiator to a target
with multiple active IB ports. The reason the orig_dgid is being used
in the above comparison instead of dgid is because these two ID's may
differ due to automatic path migration.

> > =A0static ssize_t srp_create_target(struct device *dev,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0stru=
ct device_attribute *attr,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cons=
t char *buf, size_t count)
> > @@ -2133,6 +2161,10 @@ static ssize_t srp_create_target(struct devi=
ce *dev,
> > =A0 =A0 =A0 if (ret)
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto err;
> >
> > + =A0 =A0 ret =3D srp_target_exists(host, target);
> > + =A0 =A0 if (ret)
> > + =A0 =A0 =A0 =A0 =A0 =A0 goto err;
> > +
>
> We need to tell the user that we didn't create a new connection becau=
se
> one already exists.

Does that mean that you'd like to see a pr_err() in addition to the
error code returned via the sysfs write() call ?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
