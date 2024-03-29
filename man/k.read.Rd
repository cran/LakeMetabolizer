% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/k.read.R
\name{k.read}
\alias{k.read}
\alias{k.read.soloviev}
\alias{k.cole}
\alias{k.macIntyre}
\alias{k.crusius}
\alias{k.vachon}
\alias{k.heiskanen}
\title{Returns a timeseries of gas exchange velocity}
\usage{
k.cole(ts.data)

k.crusius(ts.data, method='power')

k.read(ts.data, wnd.z, Kd, atm.press, lat, lake.area)

k.read.soloviev(ts.data, wnd.z, Kd, atm.press, lat, lake.area)

k.macIntyre(ts.data, wnd.z, Kd, atm.press,params=c(1.2,0.4872,1.4784))

k.vachon(ts.data, lake.area, params=c(2.51,1.48,0.39))

k.heiskanen(ts.data, wnd.z, Kd, atm.press)
}
\arguments{
\item{ts.data}{vector of datetime in POSIXct format}

\item{wnd.z}{height of wind measurement, m}

\item{Kd}{Light attenuation coefficient (Units:m^-1)}

\item{atm.press}{atmospheric pressure in mb}

\item{lat}{Latitude, degrees north}

\item{lake.area}{Lake area, m^2}

\item{method}{Only for \link{k.crusius}. String of valid method . Either "linear", "bilinear", or "power"}

\item{params}{Only for \link{k.vachon.base} and \link{k.macIntyre}. See details.}
}
\value{
Returns a data.frame with a datetime column and a k600 column. k600 is in units of meters per day (m/d).
}
\description{
Returns the gas exchange velocity based on the chosen model in units of m/day
}
\details{
Can change default parameters of MacIntyre and Vachon models. Default for Vachon is
c(2.51,1.48,0.39). Default for MacIntyre is c(1.2,0.4872,1.4784). Heiskanen 2014 uses MacIntyre
model with c(0.5,0.77,0.3) and z.aml constant at 0.15.
}
\examples{
data.path = system.file('extdata', package="LakeMetabolizer")

tb.data = load.all.data('sparkling', data.path)

ts.data = tb.data$data #pull out just the timeseries data

#calculate U10 and add it back onto the original

u10 = wind.scale(ts.data)
ts.data = rmv.vars(ts.data, 'wnd', ignore.offset=TRUE) #drop old wind speed column
ts.data = merge(ts.data, u10)                          #merge new u10 into big dataset


k600_cole = k.cole(ts.data)

k600_crusius = k.crusius(ts.data)

kd        = tb.data$metadata$averagekd
wnd.z      = 10   #because we converted to u10
atm.press  = 1018
lat       = tb.data$metadata$latitude
lake.area = tb.data$metadata$lakearea

#for k.read and k.macIntyre, we need LW_net.
#Calculate from the observations we have available.

lwnet = calc.lw.net(ts.data, lat, atm.press)
ts.data = merge(ts.data, lwnet)

k600_read = k.read(ts.data, wnd.z=wnd.z, Kd=kd, atm.press=atm.press,
lat=lat, lake.area=lake.area)

k600_soloviev = k.read.soloviev(ts.data, wnd.z=wnd.z, Kd=kd,
atm.press=atm.press, lat=lat, lake.area=lake.area)

k600_macIntyre = k.macIntyre(ts.data, wnd.z=wnd.z, Kd=kd, atm.press=atm.press)

}
\references{
Cole, J., J. Nina, and F. Caraco. \emph{Atmospheric exchange of carbon dioxide
in a low-wind oligotrophic lake measured by the addition of SF~ 6}.
Limnology and Oceanography 43 (1998): 647-656.

MacIntyre, Sally, Anders Jonsson, Mats Jansson, Jan Aberg, Damon E. Turney,
and Scott D. Miller. \emph{Buoyancy flux, turbulence, and the gas transfer
coefficient in a stratified lake}. Geophysical Research Letters 37, no. 24 (2010).

Read, Jordan S., David P. Hamilton, Ankur R. Desai, Kevin C. Rose, Sally MacIntyre,
John D. Lenters, Robyn L. Smyth et al. \emph{Lake-size dependency of wind shear and convection
as controls on gas exchange}. Geophysical Research Letters 39, no. 9 (2012).

Crusius, John, and Rik Wanninkhof. \emph{Gas transfer velocities measured at low
wind speed over a lake}. Limnology and Oceanography 48, no. 3 (2003): 1010-1017.

Dominic Vachon and Yves T. Prairie. \emph{The ecosystem size and shape dependence
of gas transfer velocity versus wind speed relationships in lakes}.
Can. J. Fish. Aquat. Sci. 70 (2013): 1757-1764.

Jouni J. Heiskanen, Ivan Mammarella, Sami Haapanala, Jukka Pumpanen, Timo Vesala, Sally MacIntyre
Anne Ojala.\emph{ Effects of cooling and internal wave motions on gas
transfer coefficients in a boreal lake}. Tellus B 66, no.22827 (2014)

Alexander Soloviev, Mark Donelan, Hans Graber, Brian Haus, Peter Schlussel.
\emph{An approach to estimation of near-surface turbulence and CO2 transfer
velocity from remote sensing data}. Journal of Marine Systems 66, (2007): 182-194.
}
\seealso{
\link{k.cole}
\link{k.crusius}
\link{k.macIntyre}
\link{k.vachon}
\link{k.heiskanen}
}
\author{
Hilary Dugan, Jake Zwart, Luke Winslow, R. Iestyn. Woolway, Jordan S. Read
}
\keyword{math}
\keyword{methods}
